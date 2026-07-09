#!/usr/bin/env bash
#
# hermes-focus.sh — focus the Hermes chat composer from a Waybar button.
#
# Waybar (a separate process) can't poke Electron's renderer directly, so we:
#   1. raise the Hermes window via Hyprland (hyprctl dispatch focuswindow)
#   2. fire Ctrl+Shift+L via ydotool, which Hermes's "Focus composer"
#      keybind (composer.focus) maps to -> drops focus into the chat input.
#
# ydotoold is already running and owns the socket below, so no sudo needed.

set -euo pipefail

# ydotool talks to its daemon over this socket (set by the running ydotoold).
export YDOTOOL_SOCKET="${YDOTOOL_SOCKET:-/run/user/1000/.ydotool_socket}"

HERMES_CLASS="Hermes"

# --- 1. Make sure Hermes is actually running; launch it if not. -----------
# `hermes desktop` is a launcher: it spawns the Electron child and then the
# launcher itself exits (often with code 1 because the optional sandbox-helper
# sudo step can't prompt for a password in a non-interactive shell). The
# Electron window keeps running regardless, so we ignore the launcher's exit
# code and poll for the window instead.
hermes_window_up() {
  hyprctl clients -j 2>/dev/null | grep -qi "\"class\":\"${HERMES_CLASS}\""
}

if ! hermes_window_up; then
  if command -v hermes >/dev/null 2>&1; then
    nohup hermes desktop >/dev/null 2>&1 &
    # Electron needs a few seconds to paint its first window.
    for _ in $(seq 1 20); do
      sleep 0.5
      hermes_window_up && break
    done
  fi
fi

# --- 2. Raise the Hermes window to the front. -----------------------------
if command -v hyprctl >/dev/null 2>&1; then
  hyprctl dispatch focuswindow "class:${HERMES_CLASS}" >/dev/null 2>&1 || true
fi

# Let the focus switch settle before injecting the keystroke.
sleep 0.2

# --- 3. Send Ctrl+Shift+L  (LeftCtrl=29, LeftShift=42, L=38). -------------
# key:down ... key:up ordering keeps modifiers held while L is pressed.
ydotool key 29:1 42:1 38:1 38:0 42:0 29:0
