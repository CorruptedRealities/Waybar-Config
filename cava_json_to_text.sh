#!/bin/bash
cava -p ~/.config/waybar/cava_config | while read -r line; do
  bars=$(echo "$line" | sed 's/./█/g')
  echo "$bars" 2>/dev/null
  sleep 0.03
done
