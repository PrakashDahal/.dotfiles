#!/bin/bash

battery_level=$(cat /sys/class/power_supply/BAT0/capacity)
status=$(cat /sys/class/power_supply/BAT0/status)
battery_low="$HOME/Documents/dotfiles/scripts/sounds/battery-low.wav"
battery_full="$HOME/Documents/dotfiles/scripts/sounds/battery-full.wav"

# Alert for low battery
if [ "$battery_level" -le 20 ] && [ "$status" = "Discharging" ]; then
    notify-send -u critical "Battery Low" "Battery is at ${battery_level}%. Plug in charger."
    paplay "$battery_low"
fi

# Alert for high battery
if [ "$battery_level" -ge 95 ] && [ "$status" = "Charging" ]; then
    notify-send -u normal "Battery Full" "Battery is at ${battery_level}%. Unplug charger."
    paplay "$battery_full"
fi

