#!/usr/bin/env bash
# retheme-current.sh — re-run matugen against whatever wallpaper is CURRENTLY
# displayed (variety clock/quote effects, awww, or a manual swap), so the rice
# recolors even when the wallpaper changed outside the SUPER+X picker.
set -euo pipefail
CFG="${1:-$HOME/.config/matugen/config.toml}"

# Best-effort: ask awww for the image currently on the first monitor.
IMG=$(awww query 2>/dev/null | grep -oP '(?<=image: ).+' | head -1 || true)
# Fallback to variety's recorded wallpaper, then to a known file.
[ -z "$IMG" ] && IMG=$(cat "$HOME/.config/variety/.current_wallpaper" 2>/dev/null | head -1)
[ -z "$IMG" ] && IMG=$(grep -m1 'wallpaper = ,' "$HOME/.config/hypr/hyprpaper.conf" 2>/dev/null | sed 's/.*,//')
[ -f "$IMG" ] || { echo "no current wallpaper found" >&2; exit 1; }

matugen -c "$CFG" image "$IMG"
