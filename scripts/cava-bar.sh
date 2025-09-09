#!/bin/bash
# Converts cava raw output to a Waybar bar string

# Requires cava config to output raw bars
cava | while read -r line; do
  bars=$(echo "$line" | sed 's/./█/g')
  echo "$bars"
done
