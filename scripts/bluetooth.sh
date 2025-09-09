#!/bin/bash

ICON_Enabled="󰂯"
ICON_Disabled="󰂲"

if rfkill list bluetooth | grep -q "Soft blocked: yes"; then
    echo "{\"text\": \"$ICON_Disabled\", \"tooltip\": \"Bluetooth is Disabled\", \"class\": \"Disabled\"}"
else
    echo "{\"text\": \"$ICON_Enabled\", \"tooltip\": \"Bluetooth is Enabled\", \"class\": \"Enabled\"}"
fi
