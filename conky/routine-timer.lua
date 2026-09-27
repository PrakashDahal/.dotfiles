-- Right pane: pomodoro timer, sit/stand, break tips and what comes next.
-- Drawn by scripts/routine.py; both panes sit on the laptop screen's desktop, behind windows.

conky.config = {
    alignment = 'top_left',
    xinerama_head = 1,          -- eDP-1 (laptop) in `xrandr --listmonitors`
    gap_x = 1194,               -- 1152 + 42, same shift as the table pane
    gap_y = 42,
    background = true,
    border_inner_margin = 40,
    default_color = '#C5C8C6',
    double_buffer = true,
    draw_borders = false,
    draw_outline = false,
    draw_shades = false,
    font = 'Hack Nerd Font Mono:size=16',
    minimum_width = 680,
    maximum_width = 680,
    minimum_height = 990,
    no_buffers = true,
    out_to_console = false,
    out_to_x = true,
    own_window = true,
    own_window_class = 'Conky',
    own_window_title = 'routine-timer',
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
${execpi 1 ~/Documents/dotfiles/scripts/routine.py clock}
]]
