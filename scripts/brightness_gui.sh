#!/bin/bash
DEVICE="amdgpu_bl1"
seq 100 -10 10 | wofi --dmenu -p "Brightness" | while read -r new; do
  if [[ "$new" =~ ^[0-9]+$ ]]; then
    brightnessctl -d "$DEVICE" set "${new}%"
    exit
  fi
done
