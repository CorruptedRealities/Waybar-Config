#!/bin/bash
# ~/.config/waybar/scripts/manual_sink.sh
SINK=$(pactl list short sinks | grep -v 'monitor' | tail -n1 | cut -f1)
pactl set-default-sink "$SINK"
