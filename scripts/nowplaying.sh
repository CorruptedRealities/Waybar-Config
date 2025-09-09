#!/bin/bash

artist=$(playerctl metadata artist 2>/dev/null)
title=$(playerctl metadata title 2>/dev/null)

if [[ -n "$artist" && -n "$title" ]]; then
  echo "{\"text\": \"$artist - $title\", \"tooltip\": \"$artist - $title\"}"
else
  echo "{\"text\": \"No music playing\", \"tooltip\": \"Nothing is currently playing\"}"
fi
