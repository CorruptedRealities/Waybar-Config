#!/bin/bash
WAYBAR_CONFIG_FILE=~/.config/waybar/config-bottom.jsonc \
WAYBAR_STYLE=~/.config/waybar/style-bottom.css \
waybar &
WAYBAR_CONFIG_FILE=~/.config/waybar/config-top.jsonc \
WAYBAR_STYLE=~/.config/waybar/style-top.css \
waybar &
