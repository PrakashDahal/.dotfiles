#!/bin/bash

# Delay in seconds before starting each application
sleep 3 && obsidian &
sleep 5 && brave &
sleep 10 && slack &
sleep 60 && telegram-desktop &
sleep 160 && teams &

