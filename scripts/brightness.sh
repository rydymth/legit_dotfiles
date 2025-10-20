#!/usr/bin/env bash

# ==============================
# Aurora Brightness Control Script
# Dependencies: brightnessctl
# ==============================

# Change this to your runtime output path
RUNTIME_FILE="$XDG_RUNTIME_DIR/wob.sock"

brightness_control() {
    case "$1" in
        up)
            brightnessctl set +5% >/dev/null
            ;;
        down)
            brightnessctl set 5%- >/dev/null
            ;;
        set)
            # Example: ./brightness-control.sh set 50
            if [[ -n "$2" ]]; then
                brightnessctl set "${2}%"
            else
                echo "Usage: $0 set <value>"
                exit 1
            fi
            ;;
        *)
            echo "Usage: $0 {up|down|set <value>}"
            exit 1
            ;;
    esac

    # Get current brightness (integer percentage)
    BRIGHTNESS=$(brightnessctl get)
    MAX_BRIGHTNESS=$(brightnessctl max)
    PERCENT=$(( BRIGHTNESS * 100 / MAX_BRIGHTNESS ))

    # Write JSON output for Waybar
    echo "$PERCENT" > "$RUNTIME_FILE"
}

brightness_control "$@"
