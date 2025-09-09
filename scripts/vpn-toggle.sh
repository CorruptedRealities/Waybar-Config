#!/bin/bash
# Replace 'MyVPN' with your actual VPN connection name
VPN_NAME="Corruption"

ACTIVE=$(nmcli con show --active | grep "$Corruption")

if [ "$ACTIVE" ]; then
  nmcli con down "$Corruption"
else
  nmcli con up "$Corruption"
fi
