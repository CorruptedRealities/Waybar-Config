#!/bin/bash

get_valid_sink() {
    # Try default first
    def=$(pactl get-default-sink 2>/dev/null)
    if [ -n "$def" ]; then
        echo "$def"
        return
    fi
    # Fallback to first available RUNNING sink
    pactl list short sinks | grep RUNNING | awk '{print $2}' | head -n1
}

get_valid_source() {
    def=$(pactl get-default-source 2>/dev/null)
    if [ -n "$def" ]; then
        echo "$def"
        return
    fi
    pactl list short sources | grep RUNNING | awk '{print $2}' | head -n1
}

sink=$(get_valid_sink)
source=$(get_valid_source)

volume="--"
vol_icon=""
muted=false

mic_volume="--"
mic_icon=""
mic_muted=false

# Icons
icon_muted=""
icon_low=""
icon_med=""
icon_high=""
icon_bt=""
icon_mic_on=""
icon_mic_off=""

# Get speaker data
if [ -n "$sink" ]; then
    volume=$(pactl get-sink-volume "$sink" 2>/dev/null | awk 'NR==1 {print $5}')
    muted=$(pactl get-sink-mute "$sink" 2>/dev/null | grep -q yes && echo true || echo false)
    if [[ "$volume" =~ ^[0-9]+%$ ]]; then
        vol_value=${volume%\%}
        if $muted; then
            vol_icon=$icon_muted
        elif [ "$vol_value" -lt 30 ]; then
            vol_icon=$icon_low
        elif [ "$vol_value" -lt 70 ]; then
            vol_icon=$icon_med
        else
            vol_icon=$icon_high
        fi
    fi
fi

# Get mic data
if [ -n "$source" ]; then
    mic_volume=$(pactl get-source-volume "$source" 2>/dev/null | awk 'NR==1 {print $5}')
    mic_muted=$(pactl get-source-mute "$source" 2>/dev/null | grep -q yes && echo true || echo false)
    mic_icon=$([ "$mic_muted" = true ] && echo "$icon_mic_off" || echo "$icon_mic_on")
fi

# Check for Bluetooth sink
bt_active=""
if [ -n "$sink" ]; then
    pactl list sinks | grep -A10 "$sink" | grep -iq "bluez" && bt_active="$icon_bt"
fi

# JSON output
echo "{\"text\": \"$volume $vol_icon$bt_active $mic_volume $mic_icon\", \"tooltip\": \"Speaker: $volume\\nMic: $mic_volume\", \"class\": \"pipewire-audio\"}"
