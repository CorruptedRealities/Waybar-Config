#!/bin/bash

VPN_NAME="Corruption"
ACTIVE=$(nmcli con show --active | grep "$Corruption")

if [ "$ACTIVE" ]; then
  echo "🛡 VPN ON"
else
  echo "❌ VPN OFF"
fi
