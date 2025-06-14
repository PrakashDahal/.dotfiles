#!/bin/bash

# Get battery percentage (assuming BAT0)
battery_level=$(cat /sys/class/power_supply/BAT0/capacity)
status=$(cat /sys/class/power_supply/BAT0/status)

# Send notification if battery is below 20% and discharging
if [ "$battery_level" -ge 20 ] && [ "$status" = "Discharging" ]; then
    notify-send -u critical "Battery Low" "Battery level is at ${battery_level}%"
fi

