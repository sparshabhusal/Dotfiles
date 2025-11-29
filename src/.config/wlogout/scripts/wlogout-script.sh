# --- 🚀 https://github.com/sparshabhusal ✨ --- #
#!/bin/bash

# -------------------------------------------
# Arch Linux Universal Logout Script
# Auto-adds passwordless rule for restarting DM
# Cleanly exits Hyprland → restarts DM → returns to login screen
# -------------------------------------------

# --- Detect Display Manager (Arch uses a symlink here) ---
DM_SERVICE="$(basename "$(readlink -f /etc/systemd/system/display-manager.service)")"

# Fallback (rare)
[ -z "$DM_SERVICE" ] && DM_SERVICE="display-manager.service"

# --- Ensure passwordless permission exists ---
SUDOERS_FILE="/etc/sudoers.d/99-arch-logout"

if ! sudo grep -q "systemctl restart $DM_SERVICE" "$SUDOERS_FILE" 2>/dev/null; then
    echo "Adding passwordless restart rule for $DM_SERVICE..."

    # Create sudoers rule safely
    echo "%wheel ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart $DM_SERVICE" \
    | sudo tee "$SUDOERS_FILE" >/dev/null

    # Correct permissions (required)
    sudo chmod 440 "$SUDOERS_FILE"
fi

# --- Exit Hyprland cleanly ---
if pgrep -x "Hyprland" >/dev/null; then
    hyprctl dispatch exit 2>/dev/null || pkill Hyprland
fi

# small delay so Hyprland closes
sleep 0.3

# --- Restart Display Manager ---
sudo systemctl restart "$DM_SERVICE"

