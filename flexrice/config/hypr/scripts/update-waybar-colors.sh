#!/usr/bin/env bash

WALLPAPER="$1"
COLORS_DIR="$HOME/.config/waybar/colors"
mkdir -p "$COLORS_DIR"

# Generate colors using imagemagick (fallback to pywal if needed)
if ! command -v convert &> /dev/null; then
    wal -i "$WALLPAPER" -n -q -t
    FOREGROUND=$(grep -E "foreground.*#\w+" "$HOME/.cache/wal/colors.json" -o | head -1 | cut -d'"' -f4)
    BACKGROUND=$(grep -E "background.*#\w+" "$HOME/.cache/wal/colors.json" -o | head -1 | cut -d'"' -f4)
    COLOR1=$(grep -E "color1.*#\w+" "$HOME/.cache/wal/colors.json" -o | head -1 | cut -d'"' -f4)
else
    # Using imagemagick to get dominant colors
    FOREGROUND=$(convert "$WALLPAPER" -resize 25% -colors 8 -unique-colors txt:- | grep -Eo "#\w{6}" | head -1)
    BACKGROUND=$(convert "$WALLPAPER" -resize 25% -colors 8 -unique-colors txt:- | grep -Eo "#\w{6}" | tail -1)
    COLOR1=$(convert "$WALLPAPER" -resize 25% -colors 8 -unique-colors txt:- | grep -Eo "#\w{6}" | head -2 | tail -1)
fi

# Generate CSS file
cat > "$COLORS_DIR/colors.css" <<EOF
/* Auto-generated from wallpaper */
@define-color background ${BACKGROUND}ee;
@define-color foreground ${FOREGROUND};
@define-color workspaces-bg ${COLOR1}33;
@define-color workspaces-active-bg ${COLOR1}66;
@define-color modules-bg ${BACKGROUND}4d;
@define-color critical #f38ba866;
@define-color border ${FOREGROUND}80;
EOF

# Reload Waybar
killall -SIGUSR2 waybar
