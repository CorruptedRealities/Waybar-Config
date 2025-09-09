#!/bin/bash

MAXLEN=60

title=$(hyprctl activewindow -j | jq -r '.title // "No window"')

# Truncate if longer than MAXLEN
if [ ${#title} -gt $MAXLEN ]; then
  title="${title:0:$MAXLEN}…"
fi

echo "{\"text\": \"$title\", \"tooltip\": \"$title\"}"
