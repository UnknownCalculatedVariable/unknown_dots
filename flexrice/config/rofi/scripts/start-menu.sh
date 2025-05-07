#!/bin/bash

# Replace "Your Name" with your actual name
USER_NAME="Shreeraam"

# Rofi command
rofi_cmd() {
    rofi -dmenu \
        -p "$USER_NAME" \
        -theme-str 'window {width: 20%;} listview {lines: 5;}'
}

# Get current power profile with indentation to match other options
current_profile() {
    current=$(powerprofilesctl get)
    echo "  Power Profile: ${current^}"
}

# Menu options
options=(
    "  Power Off"
    "  Restart"
    "  Update System"
    "  Update Distrobox"
    "  Backup"
    "$(current_profile)"
)

# Show menu
chosen=$(printf '%s\n' "${options[@]}" | rofi_cmd)

# Handle selection
case "$chosen" in
    "  Power Off")
        systemctl poweroff
        ;;
    "  Restart")
        systemctl reboot
        ;;
    "  Update System")
        alacritty -e bash -c "sudo pacman -Syu; read -p 'Press enter to close...'"
        ;;
    "  Update Distrobox")
        alacritty -e bash -c "distrobox-upgrade -a"
        ;;	
    "  Backup")
        alacritty -e bash -c "~/.local/bin/bckp; read -p 'Press enter to close...'"
        ;;
    "  Power Profile: "*)
        # Get current profile and toggle to next one
        current=$(powerprofilesctl get)
        case "$current" in
            "power-saver")
                new_profile="balanced"
                ;;
            "balanced")
                new_profile="performance"
                ;;
            "performance")
                new_profile="power-saver"
                ;;
            *)
                new_profile="balanced"
                ;;
        esac
        powerprofilesctl set "$new_profile"
        # Relaunch the script to show updated profile
        $0
        ;;
esac
