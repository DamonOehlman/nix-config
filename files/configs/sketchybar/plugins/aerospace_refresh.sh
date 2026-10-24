#!/usr/bin/env bash
export PATH="/opt/homebrew/bin:$HOME/.nix-profile/bin:/usr/bin:/bin"

focused="$(aerospace list-workspaces --focused 2>/dev/null || true)"
[[ -z "$focused" ]] && exit 0
sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$focused"
