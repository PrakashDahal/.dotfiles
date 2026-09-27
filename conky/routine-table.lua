-- Left pane: today's routine with steps, current row highlighted.
-- Drawn by scripts/routine.py; both panes sit on the laptop screen's desktop, behind windows.

conky.config = {
    alignment = 'top_left',
    xinerama_head = 1,          -- eDP-1 (laptop) in `xrandr --listmonitors`
    gap_x = 42,                 -- conky shifts the window left by the 40 px margin + 2
    gap_y = 42,
    background = true,
    border_inner_margin = 40,
    default_color = '#C5C8C6',
    double_buffer = true,
    draw_borders = false,
    draw_outline = false,
    draw_shades = false,
    font = 'Hack Nerd Font Mono:size=16',
    minimum_width = 1072,
    maximum_width = 1072,
    minimum_height = 990,
    no_buffers = true,
    out_to_console = false,
    out_to_x = true,
    own_window = true,
    own_window_class = 'Conky',
    own_window_title = 'routine-table',
    own_window_type = 'override',
    own_window_transparent = false,
    own_window_argb_visual = true,
    own_window_argb_value = 170,
    own_window_colour = '#1C1E21',
    text_buffer_size = 16384,
    update_interval = 1,
    use_xft = true,
}

conky.text = [[
${execpi 1 ~/Documents/dotfiles/scripts/routine.py table}
]]
