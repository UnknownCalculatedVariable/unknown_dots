#!/usr/bin/env bash

# Directory to store the generated colors
COLORS_DIR="$HOME/.config/waybar/colors"
mkdir -p "$COLORS_DIR"

# Get current wallpaper path from swww
WALLPAPER=$(swww query | awk -F 'image: ' '{print $2}' | xargs)

# Generate color palette using pywal (install with: pip install pywal)
wal -i "$WALLPAPER" -n -q -t -e

# Convert pywal colors to Waybar CSS
cat > "$COLORS_DIR/colors.css" <<EOF
/* Auto-generated from wallpaper */
@define-color background ${"${foreground}"}ee;
@define-color foreground ${"${background}"};
@define-color workspaces-bg ${"${color1}"}33;
@define-color workspaces-active-bg ${"${color2}"}66;
@define-color modules-bg ${"${color3}"}4d;
@define-color critical ${"${color5}"}66;
@define-color border ${"${color4}"}80;
EOF

# Reload Waybar
killall -SIGUSR2 waybar
