#!/usr/bin/env bash
# hermes-float.sh — launch a minimal floating Hermes chat window.
#
# Opens Hermes' terminal TUI (textbox + conversation output, nothing else)
# in a floating window governed by Hyprland window rules (class: hermes-float).
# Every launch starts a BRAND NEW session (no --resume / --continue).
#
# Terminal is selectable via HERMES_FLOAT_TERM (kitty | alacritty), default kitty.
set -euo pipefail

CLASS="hermes-float"
TERM="${HERMES_FLOAT_TERM:-kitty}"

# No head/title chrome from Hermes itself: the TUI is already just the
# conversation + input line. A fresh session is the default with no resume flag.
HERMES_CMD=(hermes chat --tui)

case "$TERM" in
  kitty)
    exec kitty --class "$CLASS" -e "${HERMES_CMD[@]}"
    ;;
  alacritty)
    exec alacritty --class "$CLASS" -e "${HERMES_CMD[@]}"
    ;;
  *)
    echo "hermes-float: unknown HERMES_FLOAT_TERM '$TERM' (use kitty|alacritty)" >&2
    exit 1
    ;;
esac
