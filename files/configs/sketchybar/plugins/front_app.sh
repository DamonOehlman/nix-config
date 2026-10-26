#!/usr/bin/env bash
export PATH="/opt/homebrew/bin:$HOME/.nix-profile/bin:/usr/bin:/bin"

app="$(aerospace list-windows --focused --format '%{app-name}' 2>/dev/null || true)"
if [[ -z "$app" ]]; then
  sketchybar --set "$NAME" label=""
else
  sketchybar --set "$NAME" label="$app"
fi
