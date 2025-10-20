#!/usr/bin/env bash

# ==============================
# Aurora Volume Control Script
# Dependencies: pactl, pamixer
# ==============================

# Change this to your runtime output path
RUNTIME_FILE="$XDG_RUNTIME_DIR/wob.sock"

# Function: control volume
volume_control() {
    case "$1" in
        up)
            pactl set-sink-volume @DEFAULT_SINK@ +5%
            ;;
        down)
            pactl set-sink-volume @DEFAULT_SINK@ -5%
            ;;
        mute)
            pactl set-sink-mute @DEFAULT_SINK@ toggle
            ;;
        *)
            echo "Usage: $0 {up|down|mute|status}"
            exit 1
            ;;
    esac

    # Get current volume and mute status using pamixer
    VOL=$(pamixer --get-volume)
    MUTED=$(pamixer --get-mute)

    # Write to runtime file (Waybar or anything can read this)
    echo "$VOL" > "$RUNTIME_FILE"
}

# Execute function with whatever argument is passed
volume_control "$1"
