# --- 🚀 https://github.com/sparshabhusal ✨ --- # 
#!/bin/zsh

echo "
restarting waybar...
"

pkill -x waybar >/dev/null 2>&1
sleep 0.3
waybar & disown

