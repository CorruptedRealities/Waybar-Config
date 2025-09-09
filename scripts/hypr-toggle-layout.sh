#!/usr/bin/env bash

STYLE_FILE="${HOME}/.cache/waybar_layout_style"
CONFIG_FILE="${HOME}/.config/waybar/config"
STYLE=$(cat "$STYLE_FILE" 2>/dev/null || echo "text")

# Switch layout
DEVICE=$(hyprctl devices -j | jq -r '.keyboards[0].name')
hyprctl switchxkblayout "$DEVICE" next

# Toggle style
if [[ "$STYLE" == "text" ]]; then
    echo "flag" > "$STYLE_FILE"
else
    echo "text" > "$STYLE_FILE"
fi

# Reload waybar with new style
pkill waybar
sleep 0.2

if [[ "$STYLE" == "text" ]]; then
    waybar -c ~/.config/waybar/config-flag.json &
else
    waybar -c ~/.config/waybar/config-text.json &
fi
