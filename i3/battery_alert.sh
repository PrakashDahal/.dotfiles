#!/bin/bash

battery_path="/sys/class/power_supply/BAT0"
[ -d "$battery_path" ] || exit 0

battery_level=$(cat "$battery_path/capacity" 2>/dev/null) || exit 0
status=$(cat "$battery_path/status" 2>/dev/null)

if [ "$battery_level" -le 20 ] && [ "$status" = "Discharging" ]; then
    notify-send -u critical "Battery Low" "Battery level is at ${battery_level}%"
fi

