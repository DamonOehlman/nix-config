#!/usr/bin/env bash
export PATH="/opt/homebrew/bin:$HOME/.nix-profile/bin:/usr/bin:/bin"

mode="$(aerospace list-modes --current 2>/dev/null || echo main)"
if [[ "$mode" == "main" || -z "$mode" ]]; then
  sketchybar --set "$NAME" drawing=off
else
  sketchybar --set "$NAME" drawing=on label="$mode"
fi
