#!/usr/bin/env bash
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
# shellcheck source=/dev/null
source "$CONFIG_DIR/colors.sh"

percent="$(pmset -g batt | grep -Eo '[0-9]+%' | head -1 | tr -d '%')"
[[ -z "$percent" ]] && percent=0

charging=""
if pmset -g batt | grep -q 'AC Power'; then
  charging=1
fi

icon="󰁹"
color="$TEXT"
if [[ -n "$charging" ]]; then
  icon="󰂄"
  color="$GREEN"
elif (( percent <= 15 )); then
  icon="󰂎"
  color="$RED"
elif (( percent <= 40 )); then
  icon="󰁻"
  color="$PEACH"
elif (( percent <= 70 )); then
  icon="󰁾"
else
  icon="󰂂"
fi

sketchybar --set "$NAME" icon="$icon" icon.color="$color" label="${percent}%"
