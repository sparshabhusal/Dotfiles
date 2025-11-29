#!/bin/bash

# =====================================================
#      Sparsha's Hyprland Dotfiles Uninstaller (v1.1.0)
# =====================================================

# -------- COLORS --------
BLUE="\033[1;34m"
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
RESET="\033[0m"

# -------- HELPER FUNCTIONS --------
line() { echo -e "${BLUE}---------------------------------------${RESET}"; }
info() { echo -e "${CYAN}[ INFO ]${RESET} $1"; }
caution() { echo -e "${RED}[ CAUTION ]${RESET} $1"; }
remove_msg() { echo -e "${GREEN}[ REMOVE ]${RESET} $1"; }
abort() {
    echo -e "\n${RED}-------------------------------------${RESET}"
    echo -e "${RED}       Uninstallation Aborted${RESET}"
    echo -e "${RED}-------------------------------------${RESET}"
    exit 1
}

# =====================================================
# 0. STARTUP LOADING MESSAGES
# =====================================================
clear
echo -e "${CYAN}[SCRIPT]${RESET} Loading environment ..."
sleep 0.3
echo -e "${CYAN}[SCRIPT]${RESET} Loading script ..."
sleep 0.3
echo -e "${CYAN}[SCRIPT]${RESET} Loading commands ..."
sleep 0.5
echo ""

# =====================================================
# 1. CHECK IF SYSTEM IS ARCH-BASED
# =====================================================
line
info "Checking if your system is Arch-based..."
sleep 0.5

if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    if [[ "$ID" == "arch" || "$ID_LIKE" == *"arch"* ]]; then
        info "Arch-based system detected (${NAME})."
    else
        echo ""
        echo -e "${RED}[ ERROR ]${RESET} This script only supports Arch-based systems."
        echo -e "${YELLOW}[ NOTE ]${RESET} Detected system: ${NAME:-Unknown}"
        abort
    fi
else
    echo -e "${RED}[ ERROR ]${RESET} Cannot detect operating system type."
    abort
fi
sleep 1
clear

# =====================================================
# 2. HEADER
# =====================================================
line
echo -e "${GREEN}            Sparsha's${RESET}"
echo -e "${GREEN}                HYPRLAND DOTS${RESET}"
line
echo -e " ・ Version 1.2.5 | ・   2025  "
line
sleep 1
echo ""

# =====================================================
# 3. CONFIRMATION
# =====================================================
line
caution "If you proceed, ONLY and specifically, the following will be uninstalled:"
echo -e " 1. Wallpapers"
echo -e " 2. Hyprland"
echo -e " 3. Kitty"
echo -e " 4. Rofi"
echo -e " 5. Thunar"
echo -e " 6. Waybar"
echo -e " 7. Pywal"
echo -e " 8. Swww"
echo -e " 9. SDDM and the SDDM theme (if installed)"
echo -e "10. Zsh, Oh-My-Zsh, Powerlevel10k"
echo -e "11. Wlogout, Hypridle, Hyprlock"
echo -e "12. tty-clock, cmatrix, cava, fastfetch"
echo -e "13. The Hyprland Dotfiles Directory"
line
read -rp "$(echo -e ${RED}'Do you want to continue? [y/n]: '${RESET})" ans
[[ $ans != [Yy]* ]] && abort
echo ""

# =====================================================
# 4. UNINSTALLATION PHASE
# =====================================================
info "Starting uninstallation..."
sleep 0.5

# --- Remove wallpapers ---
remove_msg "Removing Wallpapers..."
[[ -d ~/Pictures/Wallpapers ]] && rm -rf ~/Pictures/Wallpapers

# --- Remove Hyprland, Kitty, Rofi, Thunar ---
remove_msg "Removing Hyprland, Kitty, Rofi, and Thunar..."
for pkg in hyprland kitty rofi thunar; do
    if pacman -Qi "$pkg" &>/dev/null; then
        sudo pacman -Rns --noconfirm "$pkg"
    fi
done

# --- Remove Waybar ---
remove_msg "Removing Waybar..."
if yay -Q waybar &>/dev/null; then
    yay -Rns --noconfirm waybar
fi
[[ -d ~/.config/waybar ]] && rm -rf ~/.config/waybar

# --- Remove Pywal and Swww ---
remove_msg "Removing Pywal and Swww..."
for pkg in pywal swww; do
    if yay -Q "$pkg" &>/dev/null; then
        yay -Rns --noconfirm "$pkg"
    fi
done

# --- Remove SDDM and Theme ---
remove_msg "Removing SDDM and SDDM Theme..."
if yay -Q sddm &>/dev/null; then
    yay -Rns --noconfirm sddm
fi
[[ -d /usr/share/sddm/themes/silent ]] && sudo rm -rf /usr/share/sddm/themes/silent

# --- Remove utilities ---
remove_msg "Removing Wlogout, Hypridle, Hyprlock, tty-clock, cmatrix, cava, fastfetch..."
for pkg in wlogout hyprlock hypridle tty-clock cmatrix cava fastfetch; do
    if yay -Q "$pkg" &>/dev/null; then
        yay -Rns --noconfirm "$pkg"
    fi
done
[[ -d ~/.config/fastfetch ]] && rm -rf ~/.config/fastfetch
[[ -f ~/.config/hypr/hypridle.conf ]] && rm -f ~/.config/hypr/hypridle.conf
[[ -f ~/.config/hypr/hyprlock.conf ]] && rm -f ~/.config/hypr/hyprlock.conf

# --- Remove Zsh and related configs ---
remove_msg "Removing Zsh, Oh-My-Zsh, Powerlevel10k..."
if yay -Q zsh &>/dev/null; then
    yay -Rns --noconfirm zsh
fi
[[ -f ~/.zshrc ]] && rm -f ~/.zshrc
[[ -f ~/.zsh_history ]] && rm -f ~/.zsh_history
[[ -d ~/.oh-my-zsh ]] && rm -rf ~/.oh-my-zsh
[[ -f ~/.p10k.zsh ]] && rm -f ~/.p10k.zsh
[[ -f ~/.shell.pre-oh-my-zsh ]] && rm -f ~/.shell.pre-oh-my-zsh

# --- Remove user dotfiles ---
remove_msg "Removing Dotfiles folder..."
[[ -d ~/Dotfiles ]] && rm -rf ~/Dotfiles


# =====================================================
# 5. FINAL STATUS & REBOOT PROMPT
# =====================================================
line
echo -e "${GREEN}-----------------------------------------${RESET}"
echo -e "${GREEN}       Uninstallation Finished${RESET}"
echo -e "${GREEN}-----------------------------------------${RESET}"
echo ""
read -rp "$(echo -e ${GREEN}'Do you want to reboot now? [y/n]: '${RESET})" ans
echo ""
if [[ $ans == [Yy]* ]]; then
    sudo reboot
else
    echo -e "${RED}-----------------------------------------${RESET}"
    echo -e "${RED}       Reboot Skipped${RESET}"
    echo -e "${RED}-----------------------------------------${RESET}"
    exit 0
fi

