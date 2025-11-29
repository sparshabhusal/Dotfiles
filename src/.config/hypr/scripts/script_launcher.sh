# --- 🚀 https://github.com/sparshabhusal ✨ --- # 
#!/bin/bash

SCRIPT_DIR="$HOME/.config/hypr/scripts"

[ -d "$SCRIPT_DIR" ] || { echo "Script folder not found!"; exit 1; }

declare -A MAP
LIST=""

for file in "$SCRIPT_DIR"/*.sh; do
    [ -e "$file" ] || continue
    
    # Skip unwanted scripts
    basefile=$(basename "$file")
    if [[ "$basefile" == "startup.sh" || "$basefile" == "logout.sh" || "$basefile" == "wlogout-script.sh" ]]; then
        continue
    fi

    displayname=$(basename "$file" .sh)
    displayname="${displayname//_/ }"
    displayname="${displayname//-/ }"
    displayname="$(echo "$displayname" | awk '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) substr($i,2) } print}')"

    MAP["$displayname"]="$file"
    LIST+="$displayname"$'\n'
done

[ -z "$LIST" ] && { echo "No scripts to run!"; exit 1; }

CHOICE=$(printf "%s" "$LIST" | sort | rofi -dmenu -p "Scripts")

[ -z "$CHOICE" ] && exit

bash -- "${MAP[$CHOICE]}" &

