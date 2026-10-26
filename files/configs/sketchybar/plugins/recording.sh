#!/usr/bin/env bash
# The native "Stop Recording" status item lives in the menu bar, which
# SketchyBar covers. Its presence is the signal: macOS shows it whenever a
# recording can be stopped, including the pre-roll the Screenshot toolbar
# starts as soon as it opens in video mode.

out="$(osascript -e 'tell application "System Events" to tell process "screencaptureui" to count menu bar items of menu bar 1' 2>&1)"

# osascript errors are prefixed with "line:column:", so the reply is only a
# count when the whole string is digits.
if [[ "$out" =~ ^[0-9]+$ ]]; then
  if (( out > 0 )); then
    sketchybar --set "$NAME" drawing=on
  else
    sketchybar --set "$NAME" drawing=off
  fi
elif [[ "$out" == *-1728* || "$out" == *-1719* ]]; then
  # No screencaptureui process, or it has no status item.
  sketchybar --set "$NAME" drawing=off
else
  # Usually Accessibility not granted to SketchyBar, which would otherwise
  # fail silently forever.
  printf 'recording.sh: %s\n' "$out" >&2
  sketchybar --set "$NAME" drawing=off
fi
