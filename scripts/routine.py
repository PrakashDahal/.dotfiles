#!/usr/bin/env python3
"""Show today's routine from routine.md, with the current block highlighted.

Usage:
  routine.py bar    [--at HH:MM[:SS]] [--day WEEKDAY]   one line for polybar
  routine.py table  [--at HH:MM[:SS]] [--day WEEKDAY]   left conky pane: the day
  routine.py clock  [--at HH:MM[:SS]] [--day WEEKDAY]   right conky pane: timer
  routine.py watch                                      notify on every change
                                                        (runs as a systemd service)
  routine.py timer pause|skip|reset                     control the pomodoro timer

The file path comes from $ROUTINE_FILE. Only the "## Current" section is
read: its "### Sunday–Friday" and "### Saturday" tables. Times are 12-hour
without am/pm, so a time smaller than the previous one gets +12 hours.

A row whose block starts with "↳" or "- " is a step inside the main block
above it, for example:

  | 9:45–2:00   | First half + lunch       |
  | 9:45–12:45  | ↳ Deep work (pomodoro)   |
  | 12:45–1:30  | ↳ Lunch                  |

Pomodoro: a step with "pomodoro" in its name is split into 35 min focus and
3 min breaks; every third break is 5 min. A main block with "pomodoro" in its
name is split the same way, unless it has steps (then only its steps count).
Focus sessions alternate sit / stand, starting with sit.
"""

import argparse
import json
import os
import re
import subprocess
import sys
import time
from datetime import datetime

DEFAULT_FILE = os.path.expanduser(
    "~/Documents/HDD/myFiles/personal-life/entrepreneur/routine.md"
)
TIMER_FILE = os.path.expanduser("~/.cache/routine-timer.json")
DAYS = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]

FOCUS_MIN = 35
BREAK_MIN = 3
LONG_BREAK_MIN = 5
LONG_BREAK_EVERY = 3

SHORT_BREAK_TIPS = [
    "Look far away (6 m or more) for 20 s · blink slowly",
    "Drink water · roll your shoulders",
    "Walk around the room · shake out your legs",
    "Stretch neck, back and wrists",
]
LONG_BREAK_TIP = "Walk around · refill water · look out the window · stretch"

COLOR_NOW = "#F0C674"    # polybar colors.primary
COLOR_PAST = "#707880"   # polybar colors.disabled
COLOR_HEAD = "#8ABEB7"   # polybar colors.secondary
COLOR_BREAK = "#B5BD68"
COLOR_STAND = "#81A2BE"
FONT = "Hack Nerd Font Mono"

SOUND_FOCUS = "/usr/share/sounds/freedesktop/stereo/bell.oga"
SOUND_BREAK = "/usr/share/sounds/freedesktop/stereo/complete.oga"

TIME_RE = re.compile(r"^(\d{1,2}):(\d{2})\s*[–-]\s*(\d{1,2}):(\d{2})$")
STEP_RE = re.compile(r"^(↳|-)\s+")


# ---------------------------------------------------------------- parsing


def parse_tables(text):
    """Return {"weekday": [...], "saturday": [...]} of main-block dicts.

    Each block: {"start", "end", "name", "notes", "steps"}; times in minutes
    since midnight. Steps are blocks too, without their own steps.
    """
    tables = {}
    in_current = False
    rows = None
    prev = 0
    for line in text.splitlines():
        if line.startswith("## "):
            in_current = line.startswith("## Current")
            rows = None
            continue
        if not in_current:
            continue
        if line.startswith("### "):
            rows = tables.setdefault("saturday" if "saturday" in line.lower() else "weekday", [])
            prev = 0
            continue
        if rows is None or not line.startswith("|"):
            continue
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        m = TIME_RE.match(cells[0])
        if not m:
            continue
        name = cells[1].replace("**", "") if len(cells) > 1 else ""
        notes = cells[2].replace("**", "") if len(cells) > 2 else ""
        if STEP_RE.match(name) and rows:
            parent = rows[-1]
            start = fix((int(m[1]), int(m[2])), parent["start"])
            end = fix((int(m[3]), int(m[4])), start)
            parent["steps"].append(
                {"start": start, "end": end, "name": STEP_RE.sub("", name), "notes": notes}
            )
            continue
        start = fix((int(m[1]), int(m[2])), prev)
        end = fix((int(m[3]), int(m[4])), start)
        rows.append({"start": start, "end": end, "name": name, "notes": notes, "steps": []})
        prev = end
    return tables


def fix(hm, prev):
    minutes = (hm[0] % 12) * 60 + hm[1]
    while minutes < prev:
        minutes += 12 * 60
    return minutes


def fmt(minutes):
    h, m = divmod(minutes % (24 * 60), 60)
    return f"{(h - 1) % 12 + 1}:{m:02d}"


def fmt_left(seconds):
    seconds = max(0, int(seconds))
    h, rest = divmod(seconds, 3600)
    m, s = divmod(rest, 60)
    return f"{h}:{m:02d}:{s:02d}" if h else f"{m:02d}:{s:02d}"


def find_now(items, t):
    """The item running at `t` (seconds since midnight), or None."""
    for item in items:
        if item["start"] * 60 <= t < item["end"] * 60:
            return item
    return None


def find_next(items, t):
    for item in items:
        if item["start"] * 60 > t:
            return item
    return None


# ---------------------------------------------------------------- pomodoro


def is_pomodoro(item):
    return "pomodoro" in item["name"].lower()


def pomodoro_item(block, step):
    """The block or step that runs pomodoros right now, or None."""
    if block is None:
        return None
    if block["steps"]:
        return step if step and is_pomodoro(step) else None
    return block if is_pomodoro(block) else None


def build_phases(start, end):
    """Focus/break phases between start and end (seconds)."""
    phases = []
    t = start
    focus = breaks = 0
    while t < end:
        focus += 1
        e = min(t + FOCUS_MIN * 60, end)
        phases.append({"kind": "focus", "n": focus, "start": t, "end": e})
        t = e
        if t >= end:
            break
        breaks += 1
        length = LONG_BREAK_MIN if breaks % LONG_BREAK_EVERY == 0 else BREAK_MIN
        e = min(t + length * 60, end)
        phases.append({"kind": "break", "n": breaks, "start": t, "end": e})
        t = e
    return phases


def load_timer(key):
    """Timer state for this pomodoro item; fresh when the item changed."""
    try:
        with open(TIMER_FILE, encoding="utf-8") as f:
            state = json.load(f)
        if state.get("key") == key:
            return state
    except (OSError, ValueError):
        pass
    return {"key": key, "offset": 0, "paused_at": None}


def save_timer(state):
    os.makedirs(os.path.dirname(TIMER_FILE), exist_ok=True)
    with open(TIMER_FILE, "w", encoding="utf-8") as f:
        json.dump(state, f)


def effective_time(t, state, wall):
    """Timer time: real time shifted by skip/reset and frozen while paused."""
    paused = wall - state["paused_at"] if state["paused_at"] else 0
    return t - state["offset"] - paused


# ---------------------------------------------------------------- status


def status(rows, t, date, wall):
    """Everything the views need to know about time `t` (seconds)."""
    block = find_now(rows, t)
    step = find_now(block["steps"], t) if block else None
    nxt = (find_next(block["steps"], t) if block else None) or find_next(rows, t)
    s = {"block": block, "step": step, "next": nxt, "pomo": None}

    item = pomodoro_item(block, step)
    if item:
        key = f"{date} {item['start']}"
        state = load_timer(key)
        te = effective_time(t, state, wall)
        phases = build_phases(item["start"] * 60, item["end"] * 60)
        phase = next((p for p in phases if p["start"] <= te < p["end"]), None)
        focus_total = sum(1 for p in phases if p["kind"] == "focus")
        item_left = item["end"] * 60 - t
        s["pomo"] = {
            "key": key,
            "state": state,
            "phase": phase,
            "focus_total": focus_total,
            "left": min(phase["end"] - te, item_left) if phase else item_left,
            "length": (phase["end"] - phase["start"]) if phase else 1,
            "paused": bool(state["paused_at"]),
            "te": te,
        }
    current = step or block
    s["left"] = current["end"] * 60 - t if current else (nxt["start"] * 60 - t if nxt else 0)
    return s


def posture(phase):
    if phase["kind"] == "break":
        return "Stand up and move"
    return "SIT and work" if phase["n"] % 2 else "STAND and work"


def break_tip(phase):
    if phase["n"] % LONG_BREAK_EVERY == 0:
        return LONG_BREAK_TIP
    return SHORT_BREAK_TIPS[(phase["n"] - 1) % len(SHORT_BREAK_TIPS)]


def phase_label(pomo):
    phase = pomo["phase"]
    if phase is None:
        return "Focus sessions done"
    if phase["kind"] == "focus":
        return f"Focus {phase['n']}/{pomo['focus_total']}"
    long = phase["n"] % LONG_BREAK_EVERY == 0
    return "Long break" if long else "Break"


# ---------------------------------------------------------------- views


def bar_line(s, rows):
    pomo = s["pomo"]
    if pomo and pomo["phase"]:
        phase = pomo["phase"]
        text = f"{phase_label(pomo)} · {fmt_left(pomo['left'])}"
        if phase["kind"] == "focus":
            text += " · " + ("Sit" if phase["n"] % 2 else "Stand")
        else:
            text += " · " + break_tip(phase).split(" · ")[0]
        if pomo["paused"]:
            text = "⏸ " + text
        return text

    block, step, nxt = s["block"], s["step"], s["next"]
    if block:
        text = f"Now: {block['name']}"
        if step:
            text += f" › {step['name']}"
    else:
        text = "Break" if nxt and nxt is not rows[0] else "Sleep"
    if nxt:
        text += f" · Next {fmt(nxt['start'])} {nxt['name']}"
    elif rows:
        text += f" · Next {fmt(rows[0]['start'])} {rows[0]['name']}"
    return text if len(text) <= 80 else text[:79] + "…"


def clip(text, n):
    return text if len(text) <= n else text[: n - 1] + "…"


def esc(text):
    return text.replace("$", "$$")


def font(size, bold=False):
    return f"${{font {FONT}:{'bold:' if bold else ''}size={size}}}"


def clock_str(t):
    return f"{(t // 3600 - 1) % 12 + 1}:{t // 60 % 60:02d}:{t % 60:02d} {'AM' if t < 43200 else 'PM'}"


def conky_table(s, rows, t, day, clock):
    """Left pane: today's routine with steps, current row highlighted."""
    block, step = s["block"], s["step"]
    out = [
        f"{font(18, True)}${{color {COLOR_HEAD}}}ROUTINE · {day.upper()} {clock:%d %b}$color$font",
        "${hr 2}",
    ]
    for row in rows:
        span = f"{fmt(row['start'])}–{fmt(row['end'])}"
        if row is block:
            color, mark, bold = COLOR_NOW, "▶", True
        elif row["end"] * 60 <= t:
            color, mark, bold = COLOR_PAST, " ", False
        else:
            color, mark, bold = "#C5C8C6", " ", False
        out.append(
            f"{font(17, bold)}${{color {color}}}${{goto 10}}{mark}${{goto 45}}{span}"
            f"${{goto 250}}{esc(clip(row['name'], 52))}$color$font"
        )
        for st in row["steps"]:
            st_span = f"{fmt(st['start'])}–{fmt(st['end'])}"
            if st is step:
                color, mark = COLOR_NOW, "▸"
            elif st["end"] * 60 <= t:
                color, mark = COLOR_PAST, " "
            else:
                color, mark = "#A0A4A2", " "
            out.append(
                f"{font(14, st is step)}${{color {color}}}${{goto 250}}{mark}${{goto 275}}{st_span}"
                f"${{goto 450}}{esc(clip(st['name'], 48))}$color$font"
            )
    return "\n".join(out)


def upcoming(rows, t, count):
    """The next few blocks and steps after `t`, in order."""
    items = []
    for row in rows:
        if row["start"] * 60 > t:
            items.append((row["start"], row["name"], False))
        for st in row["steps"]:
            if st["start"] * 60 > t and st["start"] != row["start"]:
                items.append((st["start"], st["name"], True))
    items.sort(key=lambda x: x[0])
    return items[:count]


def conky_timer(s, rows, t, clock):
    """Right pane: the timer on top, what comes next below."""
    block, step, pomo = s["block"], s["step"], s["pomo"]
    out = [
        f"{font(18, True)}${{color {COLOR_HEAD}}}{clock:%a %d %b}${{alignr}}{clock_str(t)}$color$font",
        "${hr 2}",
        "${voffset 30}",
    ]
    if block is None:
        nxt = s["next"] or (rows[0] if rows else None)
        out.append(f"{font(44, True)}${{alignc}}Sleep$font")
        if nxt:
            out.append(f"{font(20)}${{alignc}}Next {fmt(nxt['start'])} · {esc(clip(nxt['name'], 40))}$font")
    else:
        out.append(f"{font(20, True)}${{color {COLOR_NOW}}}${{alignc}}{esc(clip(block['name'], 48))}$color$font")
        if step:
            out.append(f"{font(28, True)}${{alignc}}{esc(clip(step['name'], 36))}$font")
        current = step or block
        if pomo and pomo["phase"]:
            phase = pomo["phase"]
            is_break = phase["kind"] == "break"
            color = COLOR_PAST if pomo["paused"] else (COLOR_BREAK if is_break else COLOR_NOW)
            label = phase_label(pomo) + ("  ·  PAUSED" if pomo["paused"] else "")
            out.append(f"${{voffset 10}}{font(22)}${{alignc}}{label}$font")
            out.append(f"{font(110, True)}${{color {color}}}${{alignc}}{fmt_left(pomo['left'])}$color$font")
            width = 36
            done = 1 - pomo["left"] / pomo["length"]
            filled = max(0, min(width, round(done * width)))
            out.append(f"${{voffset 24}}{font(18)}${{color {color}}}${{alignc}}{'█' * filled}{'░' * (width - filled)}$color$font")
            pcolor = COLOR_BREAK if is_break else (COLOR_STAND if phase["n"] % 2 == 0 else COLOR_NOW)
            out.append(f"${{voffset 14}}{font(30, True)}${{color {pcolor}}}${{alignc}}{posture(phase)}$color$font")
            if is_break:
                for part in break_tip(phase).split(" · "):
                    out.append(f"{font(18)}${{alignc}}{esc(part)}$font")
        else:
            if pomo:
                out.append(f"${{voffset 10}}{font(22)}${{alignc}}{phase_label(pomo)}$font")
            out.append(f"${{voffset 10}}{font(90, True)}${{color {COLOR_NOW}}}${{alignc}}{fmt_left(s['left'])}$color$font")
            out.append(f"{font(16)}${{color {COLOR_PAST}}}${{alignc}}left in this {'step' if step else 'block'}$color$font")
        if current["notes"]:
            out.append(f"${{voffset 12}}{font(16)}${{color {COLOR_HEAD}}}${{alignc}}{esc(clip(current['notes'], 70))}$color$font")
        if pomo:
            out.append(
                f"${{voffset 12}}{font(12)}${{color {COLOR_PAST}}}${{alignc}}"
                f"Super+t then:  space pause/resume   s skip   r reset$color$font"
            )

    out.append("${voffset 30}${hr 1}")
    out.append(f"{font(16, True)}${{color {COLOR_HEAD}}}COMING UP$color$font")
    for start, name, is_step in upcoming(rows, t, 5):
        indent = "↳ " if is_step else ""
        out.append(f"{font(17)}${{goto 42}}{fmt(start)}${{goto 142}}{indent}{esc(clip(name, 44))}$font")
    return "\n".join(out)


# ---------------------------------------------------------------- notify


def notify(title, body, sound=None):
    subprocess.run(
        ["notify-send", "-a", "Routine", "-u", "normal",
         "-h", "string:x-dunst-stack-tag:routine", title, body],
        check=False,
    )
    if sound and os.path.exists(sound):
        subprocess.Popen(["paplay", sound], stderr=subprocess.DEVNULL)


def signature(s):
    """What changed between two moments, for notifications."""
    block, step, pomo = s["block"], s["step"], s["pomo"]
    phase = pomo["phase"] if pomo else None
    return (
        block["start"] if block else None,
        step["start"] if step else None,
        (phase["kind"], phase["n"]) if phase else None,
    )


def announce(s):
    block, step, pomo = s["block"], s["step"], s["pomo"]
    if block is None:
        nxt = s["next"]
        notify("Sleep", f"Next {fmt(nxt['start'])} {nxt['name']}" if nxt else "")
        return
    phase = pomo["phase"] if pomo else None
    if phase:
        until = fmt_left(pomo["left"])
        if phase["kind"] == "focus":
            notify(f"{phase_label(pomo)} · {posture(phase)}",
                   f"{(step or block)['name']} · {until}", SOUND_FOCUS)
        else:
            notify(f"{phase_label(pomo)} · {until}", break_tip(phase), SOUND_BREAK)
        return
    current = step or block
    body = [f"{fmt(current['start'])}–{fmt(current['end'])}"]
    if current["notes"]:
        body.append(current["notes"])
    if not step and block["steps"]:
        body.append("Steps: " + " → ".join(x["name"] for x in block["steps"]))
    title = f"Now: {block['name']}" + (f" › {step['name']}" if step else "")
    notify(title, "\n".join(body), SOUND_FOCUS)


def watch(path):
    last = None
    while True:
        clock = datetime.now()
        rows = load_rows(path, DAYS[clock.weekday()])
        if rows:
            t = clock.hour * 3600 + clock.minute * 60 + clock.second
            s = status(rows, t, clock.date(), time.time())
            sig = signature(s)
            if last is not None and sig != last:
                announce(s)
            last = sig
        time.sleep(1)


# ---------------------------------------------------------------- timer


def timer_command(action, rows, t, date, wall):
    s = status(rows, t, date, wall)
    pomo = s["pomo"]
    if not pomo:
        return
    state, phase = pomo["state"], pomo["phase"]
    if action == "pause":
        if state["paused_at"]:
            state["offset"] += wall - state["paused_at"]
            state["paused_at"] = None
        else:
            state["paused_at"] = wall
    elif phase and action == "skip":
        state["offset"] = t - phase["end"]
        state["paused_at"] = None
    elif phase and action == "reset":
        state["offset"] = t - phase["start"]
        state["paused_at"] = None
    save_timer(state)


# ---------------------------------------------------------------- main


def load_rows(path, day):
    try:
        with open(path, encoding="utf-8") as f:
            tables = parse_tables(f.read())
    except OSError:
        return None
    return tables.get("saturday" if day == "saturday" else "weekday", [])


def main():
    p = argparse.ArgumentParser()
    p.add_argument("mode", choices=["bar", "table", "clock", "watch", "timer"])
    p.add_argument("action", nargs="?", choices=["pause", "skip", "reset"])
    p.add_argument("--at", help="time HH:MM[:SS] (24-hour), for testing")
    p.add_argument("--day", choices=DAYS, help="weekday, for testing")
    args = p.parse_args()

    path = os.environ.get("ROUTINE_FILE", DEFAULT_FILE)
    if args.mode == "watch":
        watch(path)
        return 0

    clock = datetime.now()
    day = args.day or DAYS[clock.weekday()]
    if args.at:
        parts = [int(x) for x in args.at.split(":")] + [0]
        t = parts[0] * 3600 + parts[1] * 60 + parts[2]
    else:
        t = clock.hour * 3600 + clock.minute * 60 + clock.second

    rows = load_rows(path, day)
    if rows is None:
        print("routine: file not found")
        return 0
    if not rows:
        print("routine: no table found")
        return 0

    wall = time.time()
    if args.mode == "timer":
        if not args.action:
            p.error("timer needs pause, skip or reset")
        timer_command(args.action, rows, t, clock.date(), wall)
        return 0

    s = status(rows, t, clock.date(), wall)
    if args.mode == "bar":
        print(bar_line(s, rows))
    elif args.mode == "table":
        print(conky_table(s, rows, t, day, clock))
    else:
        print(conky_timer(s, rows, t, clock))
    return 0


if __name__ == "__main__":
    sys.exit(main())
