#!/bin/bash

# Get all sink names (not IDs)
sinks=($(pactl list short sinks | awk '{print $2}'))

# Get current default sink
current=$(pactl info | grep "Default Sink" | awk '{print $3}')

# Find index of current sink
for i in "${!sinks[@]}"; do
    if [[ "${sinks[$i]}" = "$current" ]]; then
        current_index=$i
        break
    fi
done

# Calculate next sink index
next_index=$(( (current_index + 1) % ${#sinks[@]} ))
next_sink="${sinks[$next_index]}"

# Set default sink to the next one
pactl set-default-sink "$next_sink"

# Move all active audio streams to new sink
for input in $(pactl list short sink-inputs | awk '{print $1}'); do
    pactl move-sink-input "$input" "$next_sink"
done

# Optional debug log (for temporary testing)
#notify-send "Sink switched to: $next_sink"
#echo "Switched to $next_sink" >> /tmp/waybar_sink_switch.log
