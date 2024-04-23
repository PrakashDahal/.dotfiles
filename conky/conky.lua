-- Conky, a system monitor https://github.com/brndnmtthws/conky
--
-- This configuration file is Lua code. You can write code in here, and it will
-- execute when Conky loads. You can use it to generate your own advanced
-- configurations.
--
-- Try this (remove the `--`):
--
--   print("Loading Conky config")
--
-- For more on Lua, see:
-- https://www.lua.org/pil/contents.html

conky.config = {
    alignment = 'top_right',
    background = true,
    border_width = 1,
    cpu_avg_samples = 2,
    default_color = 'white',
    default_outline_color = 'white',
    default_shade_color = 'white',
    double_buffer = true,
    draw_borders = false,
    draw_graph_borders = true,
    draw_outline = false,
    draw_shades = false,
    extra_newline = false,
    font = 'Nerd DejaVu Sans Mono:size=15',
    gap_x = 20,
    gap_y = 60,
    minimum_height = 5,
    minimum_width = 5,
    net_avg_samples = 2,
    no_buffers = true,
    out_to_console = false,
    out_to_ncurses = false,
    out_to_stderr = false,
    out_to_x = true,
    own_window = true,
    own_window_class = 'Conky',
    own_window_transparent = false,
    own_window_argb_visual = true,
    own_window_argb_value = 98,
    own_window_type = 'override',
    show_graph_range = true,
    show_graph_scale = true,
    stippled_borders = 0,
    update_interval = 1.0,
    uppercase = false,
    use_spacer = 'none',
    use_xft = true,
}

conky.text = [[
${color #F0C674}Info:$color ${scroll 32 Conky $conky_version - $sysname $nodename $kernel $machine}
$hr
${color #F0C674}Uptime:$color $uptime
${color #F0C674}Frequency:$color $freq MHz | $freq_g GHz
${color #F0C674}RAM:$color $mem/$memmax - $memperc% ${membar 4}
${color #F0C674}Swap:$color $swap/$swapmax - $swapperc% ${swapbar 4}
${color #F0C674}CPU:$color $cpu% ${cpubar 4}
${color #F0C674}Processes:$color $processes  ${color #F0C674}Running:$color $running_processes
${color #F0C674}Temperature:$color ${execi 30 sensors | grep 'Core 0' | cut -c16-17}°C
$hr
${color #F0C674}File systems:
 / $color${fs_used /}/${fs_size /} ${fs_bar 6 /}
${color #F0C674}Networking:
Up:$color ${upspeed} ${color #F0C674} - Down:$color ${downspeed}
$hr
${color #F0C674}Name              PID     CPU%   MEM%
${color lightgrey} ${top name 1} ${top pid 1} ${top cpu 1} ${top mem 1}
${color lightgrey} ${top name 2} ${top pid 2} ${top cpu 2} ${top mem 2}
${color lightgrey} ${top name 3} ${top pid 3} ${top cpu 3} ${top mem 3}
${color lightgrey} ${top name 4} ${top pid 4} ${top cpu 4} ${top mem 4}
]]
