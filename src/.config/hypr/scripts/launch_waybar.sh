#!/bin/zsh

echo "
launching waybar...
"
killall waybar 2>/dev/null
waybar &
