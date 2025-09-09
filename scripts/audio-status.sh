#!/bin/bash

# Icons
icon_muted=""
icon_low=""
icon_med=""
icon_high=""
icon_mic_on=""
icon_mic_off=""
icon_bt=""

# Get default sink and source names
default_sink=$(pactl get-default-sink)
default_source=$(pactl get-default-source)

# Return early if no sink
if [ -z "$default_sink" ]; then
  echo '{"text":"No output","class":"error"}'
  exit 0
fi

# Get sink volume and mute
sink_info=$(pactl list sinks | awk -v sink="$default_sink" '
  $0 ~ "Name: "sink {found=1}
  found && /Volume:/ && !vol {vol=$5}
  found && /Mute:/ {mute=$2; exit}
  END {print vol, mute}
')
sink_volume=$(echo "$sink_info" | awk '{print $1}' | tr -d '%')
sink_muted=$(echo "$sink_info" | awk '{print $2}')

# Get source volume and mute
source_info=$(pactl list sources | awk -v source="$default_source" '
  $0 ~ "Name: "source {found=1}
  found && /Volume:/ && !vol {vol=$5}
  found && /Mute:/ {mute=$2; exit}
  END {print vol, mute}
')
source_volume=$(echo "$source_info" | awk '{print $1}' | tr -d '%')
source_muted=$(echo "$source_info" | awk '{print $2}')

# Volume icon logic
if [[ "$sink_muted" == "yes" ]]; then
  vol_icon="$icon_muted"
else
  if [ "$sink_volume" -lt 30 ]; then
    vol_icon="$icon_low"
  elif [ "$sink_volume" -lt 70 ]; then
    vol_icon="$icon_med"
  else
    vol_icon="$icon_high"
  fi
fi

# Mic icon
if [[ "$source_muted" == "yes" ]]; then
  mic_icon="$icon_mic_off"
else
  mic_icon="$icon_mic_on"
fi

# Bluetooth indicator
bt_icon=""
if pactl list sinks short | grep "$default_sink" | grep -qi "bluez"; then
  bt_icon="$icon_bt"
fi

# Output JSON
echo "{\"text\": \"${sink_volume}% ${vol_icon}${bt_icon} | ${source_volume}% ${mic_icon}\", \"tooltip\": \"Speaker: ${sink_volume}%\\nMic: ${source_volume}%\", \"class\": \"pipewire-audio\"}"
