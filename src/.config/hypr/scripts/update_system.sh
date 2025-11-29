# --- 🚀 https://github.com/sparshabhusal ✨ --- #
#!/bin/bash

# --- CONFIG: terminal ---
TERMINAL="kitty"

# Function to run the update commands
run_updates() {
    clear
    echo "
Updating System ...
"
    sudo pacman -Syyu
    yay -Syyu
    echo "
Update finished!"
}

# Detect if script is running inside a terminal
if [ -t 1 ]; then
    # Running inside a terminal, just run updates
    run_updates
else
    # Not in a terminal, open Kitty and run this script
    $TERMINAL -e bash -c "\"$0\""
fi

