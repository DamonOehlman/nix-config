#!/usr/bin/env bash
cores="$(sysctl -n hw.ncpu 2>/dev/null || echo 1)"
load="$(ps -A -o %cpu | awk -v n="$cores" 'BEGIN {s=0} {s+=$1} END {printf "%d", s/n}')"
sketchybar --set "$NAME" label="${load}%"
