#!/bin/bash
status=$(playerctl status 2>/dev/null)
if [ -n "$status" ]; then
    position=$(playerctl position --format '{{duration(position)}}' 2>/dev/null)
    length=$(playerctl metadata --format '{{duration(mpris:length)}}' 2>/dev/null)
    echo "[$position / $length]"
else
    echo ""
fi
