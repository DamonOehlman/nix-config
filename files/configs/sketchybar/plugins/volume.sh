#!/usr/bin/env bash
volume="$(osascript -e 'output volume of (get volume settings)' 2>/dev/null || echo 0)"
muted="$(osascript -e 'output muted of (get volume settings)' 2>/dev/null || echo false)"

if [[ "$muted" == "true" || "$volume" == "0" ]]; then
  icon="󰖁"
  label="mute"
else
  if (( volume > 66 )); then
    icon="󰕾"
  elif (( volume > 33 )); then
    icon="󰖀"
  else
    icon="󰕿"
  fi
  label="${volume}%"
fi

sketchybar --set "$NAME" icon="$icon" label="$label"
