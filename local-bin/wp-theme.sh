#!/usr/bin/env bash
# wp-theme.sh — pick a wallpaper and re-theme the rice with matugen
# Usage: wp-theme.sh [path-to-image]   (no arg = open a wofi picker)
set -euo pipefail

WALL_DIR="$HOME/Pictures/wallpapers"
MATUGEN_CFG="$HOME/.config/matugen/config.toml"

pick() {
    find "$WALL_DIR" -maxdepth 2 -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) \
        | sed "s|$WALL_DIR/||" \
        | wofi --dmenu -p " wallpaper" -i
}

IMG="${1:-}"
if [[ -z "$IMG" || "$IMG" == "picker" ]]; then
    choice="$(pick)"
    [[ -z "$choice" ]] && exit 0
    IMG="$WALL_DIR/$choice"
fi
[[ -f "$IMG" ]] || { echo "no such image: $IMG" >&2; exit 1; }

# Regenerate theme (matugen sets wallpaper via the configured backend + reloads waybar)
matugen -c "$MATUGEN_CFG" image "$IMG"
