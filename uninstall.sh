#!/bin/bash

# =====================================================
#      Sparsha's Hyprland Dotfiles Uninstaller (v1.0.0)
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
abort() { echo -e "\n"; echo -e "${RED}-------------------------------------${RESET}"; echo -e "${RED}       Uninstallation Aborted${RESET}"; echo -e "${RED}-------------------------------------${RESET}"; exit 1; }

# -------- STARTUP --------
clear
info "Starting the uninstallation script..."
sleep 0.5
info "Loading commands and prompts..."
sleep 0.5
info "Preparing environment..."
sleep 0.5
echo ""
clear

# -------- ASCII HEADER --------
line
echo -e "${GREEN}            Sparsha's${RESET}"
echo -e "${GREEN}                HYPRLAND DOTS${RESET}"
line
echo -e "   ・ Version 1.0.0              ・ 2025"
line
echo ""
sleep 0.5

# -------- CONFIRMATION --------
line
caution "If you proceed, the following will be uninstalled:"
echo -e " 1. Wallpapers"
echo -e " 2. Hyprland"
echo -e " 3. Kitty"
echo -e " 4. Rofi"
echo -e " 5. Thunar"
echo -e " 6. Waybar"
echo -e " 7. Pywal"
echo -e " 8. Swww"
echo -e " 9. SDDM and the SDDM theme"
echo -e "10. Zsh, Oh-My-Zsh, Powerlevel10k"
echo -e "11. Wlogout, Hypridle, Hyprlock"
echo -e "12. tty-clock, cmatrix, cava, fastfetch"
line
read -rp "$(echo -e ${RED}'Do you want to continue? [y/n]: '${RESET})" ans

if [[ $ans != [Yy]* ]]; then
    abort
fi
echo ""

# -------- UNINSTALLATION --------
info "Starting uninstallation..."
sleep 0.5

# Remove dotfiles
remove_msg "Removing Dotfiles folder..."
[[ -d ~/Dotfiles ]] && sudo rm -rf ~/Dotfiles

# Remove wallpapers
remove_msg "Removing Wallpapers..."
[[ -d ~/Pictures/Wallpapers ]] && sudo rm -rf ~/Pictures/Wallpapers

# Remove Hyprland, Kitty, Rofi, Thunar
remove_msg "Removing Hyprland, Kitty, Rofi, and Thunar..."
sudo pacman -Rns --noconfirm hyprland kitty rofi thunar

# Remove Waybar
remove_msg "Removing Waybar..."
yay -Rns --noconfirm waybar || true
[[ -d ~/.config/waybar ]] && sudo rm -rf ~/.config/waybar

# Remove Pywal and Swww
remove_msg "Removing Pywal and Swww..."
yay -Rns --noconfirm pywal swww || true

# Remove SDDM and SDDM Theme
remove_msg "Removing SDDM and SDDM Theme..."
yay -Rns --noconfirm sddm || true
[[ -d /usr/share/sddm/themes/silent ]] && sudo rm -rf /usr/share/sddm/themes/silent

# Remove Wlogout, Hypridle, Hyprlock, tty-clock, cmatrix, cava, fastfetch
remove_msg "Removing utilities..."
yay -Rns --noconfirm wlogout hyprlock hypridle tty-clock cmatrix cava fastfetch || true
[[ -d ~/.config/fastfetch ]] && sudo rm -rf ~/.config/fastfetch
[[ -f ~/.config/hypr/hypridle.conf ]] && sudo rm -f ~/.config/hypr/hypridle.conf
[[ -f ~/.config/hypr/hyprlock.conf ]] && sudo rm -f ~/.config/hypr/hyprlock.conf

# Remove Zsh, Oh-My-Zsh, Powerlevel10k
remove_msg "Removing Zsh and related configs..."
yay -Rns --noconfirm zsh || true
[[ -f ~/.zshrc ]] && sudo rm -f ~/.zshrc
[[ -f ~/.zsh_history ]] && sudo rm -f ~/.zsh_history
[[ -d ~/.oh-my-zsh ]] && sudo rm -rf ~/.oh-my-zsh
[[ -f ~/.p10k.zsh ]] && sudo rm -f ~/.p10k.zsh
[[ -f ~/.shell.pre-oh-my-zsh ]] && sudo rm -f ~/.shell.pre-oh-my-zsh

echo ""
# -------- FINAL BANNER --------
line
echo -e "${GREEN}-----------------------------------------${RESET}"
echo -e "${GREEN}       Uninstallation Finished${RESET}"
echo -e "${GREEN}-----------------------------------------${RESET}"
echo ""

# -------- REBOOT PROMPT --------
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

