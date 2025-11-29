# --- 🚀 https://github.com/sparshabhusal ✨ --- #
#!/bin/zsh

hyprctl reload

killall waybar &
pkill waybar &

sleep 0.5

waybar

hyprctl reload
