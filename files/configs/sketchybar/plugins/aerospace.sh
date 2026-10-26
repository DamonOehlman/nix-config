#!/usr/bin/env bash
export PATH="/opt/homebrew/bin:$HOME/.nix-profile/bin:/usr/bin:/bin"

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
# shellcheck source=/dev/null
source "$CONFIG_DIR/colors.sh"
# shellcheck source=/dev/null
source "$CONFIG_DIR/plugins/icon_map.sh"

SID="$1"
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

icon_strip=""
while IFS= read -r app; do
  [[ -z "$app" ]] && continue
  __icon_map "$app"
  icon_strip+=" $icon_result"
done < <(aerospace list-windows --workspace "$SID" --format '%{app-name}' 2>/dev/null)

if [[ -z "$icon_strip" ]]; then
  icon_strip=""
fi

if [[ "$SID" == "$FOCUSED" ]]; then
  sketchybar --set "$NAME" \
    background.drawing=on \
    background.color="$SAPPHIRE" \
    icon.color="$CRUST" \
    label.color="$CRUST" \
    label.drawing=on \
    label="$icon_strip"
elif [[ -n "$icon_strip" ]]; then
  sketchybar --set "$NAME" \
    background.drawing=off \
    icon.color="$SUBTEXT1" \
    label.color="$SUBTEXT0" \
    label.drawing=on \
    label="$icon_strip"
else
  sketchybar --set "$NAME" \
    background.drawing=off \
    icon.color="$OVERLAY0" \
    label.drawing=off \
    label=""
fi
