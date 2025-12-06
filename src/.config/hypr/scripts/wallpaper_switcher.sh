# --- 🚀 https://github.com/sparshabhusal ✨ --- #
#!/usr/bin/env bash

# --- CONFIG ---
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_DIR="$HOME/.cache/wall-thumbs"
THUMB_SIZE="240x135"

mkdir -p "$CACHE_DIR"
shopt -s nullglob

declare -A file_map
menu_lines=()

# --- BUILD MENU WITH THUMBNAILS ---
for ext in jpg jpeg png; do
    for file in "$WALLPAPER_DIR"/*.$ext; do
        [ -e "$file" ] || continue

        base_name=$(basename "$file")
        pretty_name=$(basename "$file" | sed -E 's/\.[^.]+$//' \
            | sed 's/[_-]/ /g' \
            | sed 's/.*/\L&/; s/\b\(.\)/\u\1/g')

        # Thumbnail path
        thumb="$CACHE_DIR/$base_name"
        if [ ! -f "$thumb" ] || [ "$file" -nt "$thumb" ]; then
            convert "$file" -thumbnail "${THUMB_SIZE}^" \
                -gravity center -extent "$THUMB_SIZE" \
                -quality 90 "$thumb"
        fi

        menu_lines+=("$pretty_name\0icon\x1f$thumb")
        file_map["$pretty_name"]="$file"
    done
done

# If no wallpapers exist
[ ${#menu_lines[@]} -eq 0 ] && {
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
}

# --- ROFI MENU ---
selected=$(printf '%b\n' "${menu_lines[@]}" | rofi \
    -dmenu \
    -show-icons \
    -lines 5 \
    -fixed-num-lines \
    -theme-str 'listview { lines: 5; }' \
    -p "Wallpapers")

# --- USER SELECTED SOMETHING ---
if [ -n "$selected" ]; then
    filename=$(echo -n "$selected" | tr -d '\0\x1f')
    file="${file_map[$filename]}"

    # Ensure swww daemon is running
    pgrep -f swww >/dev/null || nohup swww daemon >/dev/null 2>&1 &
    sleep 0.5

    # --- 1. Apply wallpaper ---
    swww img "$file" \
        --transition-type center \
        --transition-duration 0.7 \
        --transition-bezier .5,1.3,.8,1 \
        --transition-fps 60

    sleep 0.3  # ensures swww transition finishes

    # --- 2. Run pywal (sync, NOT background) ---
    wal -i "$file" -n

    # --- 3. Export pywal colors so Waybar reads them ---
    if [ -f "$HOME/.cache/wal/colors.sh" ]; then
        source "$HOME/.cache/wal/colors.sh"
    fi

    # --- 4. Restart Waybar properly ---
    pkill waybar
    sleep 0.3
    waybar >/dev/null 2>&1 &
fi

