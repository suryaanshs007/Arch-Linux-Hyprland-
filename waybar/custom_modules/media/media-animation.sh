#!/bin/bash
status=$(playerctl status 2>/dev/null)
if [ "$status" = "Playing" ]; then
    frames=("󰝚" "󰝛" "󰝜")
    while true; do
        for frame in "${frames[@]}"; do
            echo "$frame"
            sleep 0.5
        done
    done
else
    echo "󰏤"
fi
