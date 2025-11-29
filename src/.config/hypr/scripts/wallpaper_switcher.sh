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

[ ${#menu_lines[@]} -eq 0 ] && {
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
}

# --- SHOW ROFI MENU (FORCE EXACTLY 5 LINES) ---
selected=$(printf '%b\n' "${menu_lines[@]}" | rofi \
    -dmenu \
    -show-icons \
    -lines 5 \
    -fixed-num-lines \
    -theme-str 'listview { lines: 5; }' \
    -p "Wallpapers")

if [ -n "$selected" ]; then
    filename=$(echo -n "$selected" | tr -d '\0\x1f')
    file="${file_map[$filename]}"

    echo "Selected: $selected"
    echo "Filename key: $filename"
    echo "File path: $file"

    if [ -z "$file" ] || [ ! -f "$file" ]; then
        echo "Error: File not found for selection: $filename"
        exit 1
    fi

    export PATH="/usr/bin:/bin:/usr/local/bin"
    export HOME="$HOME"
    export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
    export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-0}"

    pgrep -f swww >/dev/null || nohup swww daemon >/dev/null 2>&1 &
    sleep 0.5

    swww img "$file" --transition-fps 60 --transition-step 10
    wal -i "$file" &

    sleep 0.2
    if [ -x "$HOME/.config/hypr/scripts/restart_waybar.sh" ]; then
        "$HOME/.config/hypr/scripts/restart_waybar.sh"
    fi
fi
