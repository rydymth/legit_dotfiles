#!/usr/bin/env bash
# Configuration
WALLPAPER_DIR="$HOME/Pictures/wallpapers"  # Change this to your wallpaper directory
CACHE_DIR="$HOME/.cache/cache_wall"
THUMBNAIL_WIDTH="250"  # Size of thumbnails in pixels (16:9)
THUMBNAIL_HEIGHT="141"

# Function to generate thumbnail
generate_thumbnail() {
    local input="$1"
    local output="$2"
    convert "$input" -thumbnail "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}^" \
  -gravity center -extent "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" "$output"
}

# Generate thumbnails and create menu items
generate_menu() {
    
    # Then add all wallpapers
    for img in "$WALLPAPER_DIR"/*.{jpg,jpeg,png}; do
        # Skip if no matches found
        [[ -f "$img" ]] || continue
        
        # Generate thumbnail filename
        thumbnail="$CACHE_DIR/$(basename "${img%.*}").png"
        
        # Generate thumbnail if it doesn't exist or is older than source
        if [[ ! -f "$thumbnail" ]] || [[ "$img" -nt "$thumbnail" ]]; then
            generate_thumbnail "$img" "$thumbnail"
        fi
        
        # Output menu item (filename and path)
        echo -en "img:$thumbnail\x00info:$(basename "$img")\x1f$img\n"
    done
}

# Use wofi to display grid of wallpapers - IMPORTANT: added --sort-order=default
selected=$(generate_menu | wofi --show dmenu \
    --cache-file /dev/null \
    --define "image-size=${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" \
    --allow-images \
    --insensitive \
    --sort-order=default \
    --prompt "Select Wallpaper" \
    --conf ~/.config/wofi/wallpaper_selector \
  )

# Set wallpaper if one was selected
if [ -n "$selected" ]; then
    # Remove the img: prefix to get the cached thumbnail path
    thumbnail_path="${selected#img:}"
    # Get the original filename from the thumbnail path
    original_filename=$(basename "${thumbnail_path%.*}")
    
    # Find the corresponding original file in the wallpaper directory
    original_path=$(find "$WALLPAPER_DIR" -type f -name "${original_filename}.*" | head -n1)

    # Ensure a valid wallpaper was found before proceeding
    if [ -n "$original_path" ]; then
        # Set wallpaper using swww with the original file
	pkill swaybg
        swaybg -i "$original_path" -m fill &

	# Store current wallpaper selection
	rm $CACHE_DIR/current_wal
	echo $original_path >> $CACHE_DIR/current_wal

        # Save the selection for persistence
        echo "$original_path" > "$HOME/.cache/current_wallpaper"

        # Optional: Notify user
        notify-send "Wallpaper" "Wallpaper has been updated" -i "$original_path"
    else
        notify-send "Wallpaper Error" "Could not find the original wallpaper file."
    fi
fi
