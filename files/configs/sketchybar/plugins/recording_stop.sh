#!/usr/bin/env bash
# Stop through the control the menu bar would give us, so the recording is
# finalised and saved rather than discarded. Hide immediately; the poll brings
# the item back if the stop did not take.

osascript -e 'tell application "System Events" to tell process "screencaptureui" to click menu bar item 1 of menu bar 1' >/dev/null 2>&1
sketchybar --set "$NAME" drawing=off
