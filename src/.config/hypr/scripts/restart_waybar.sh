# --- 🚀 https://github.com/sparshabhusal ✨ --- #
#!/bin/bash

# Reload Hyprland config
hyprctl reload

# Kill all existing Waybar instances
pkill -9 waybar

# Wait a bit for Waybar to fully stop
sleep 0.3

# Start Waybar ONLY if it's not running
if ! pgrep -x "waybar" > /dev/null; then
    waybar &
fi

# Reload Hyprland again (optional)
hyprctl reload

