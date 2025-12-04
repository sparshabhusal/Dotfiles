#!/bin/bash

# =====================================================
#      Sparsha's Hyprland Dotfiles Uninstaller (v1.3)
# =====================================================

set -euo pipefail
trap "echo -e '\n\033[1;31m[ ABORTED ]\033[0m Script terminated by user.'; exit 1" INT

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

validate_yesno() {
    local var="$1"
    case "$var" in
        y|Y) return 0 ;;
        n|N) return 1 ;;
        *) echo -e "${RED}[ ERROR ]${RESET} Invalid input. Please enter y or n."; exit 1 ;;
    esac
}

check_arch() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        if [[ "$ID" != "arch" && "$ID_LIKE" != *"arch"* ]]; then
            echo -e "${RED}[ ERROR ]${RESET} This script only supports Arch-based systems."
            echo -e "${YELLOW}[ NOTE ]${RESET} Detected system: ${NAME:-Unknown}"
            abort
        fi
    else
        echo -e "${RED}[ ERROR ]${RESET} Cannot detect operating system type."
        abort
    fi
}

# =====================================================
#  STARTUP
# =====================================================
clear
check_arch
echo -e "${CYAN}[SCRIPT]${RESET} Loading environment ..."
sleep 0.3
echo -e "${CYAN}[SCRIPT]${RESET} Loading script ..."
sleep 0.3
echo -e "${CYAN}[SCRIPT]${RESET} Loading commands ..."
sleep 0.5
echo ""

# =====================================================
#  HEADER
# =====================================================
line
echo -e "${GREEN}            Sparsha's${RESET}"
echo -e "${GREEN}                HYPRLAND DOTS${RESET}"
line
echo -e " ・ Version 1.3 | ・   2025  "
line
sleep 1
echo ""

# =====================================================
#  CONFIRMATION
# =====================================================
line
caution "If you proceed, the following will be uninstalled:"
echo -e "  • Wallpapers"
echo -e "  • Hyprland, Kitty, Rofi, Thunar"
echo -e "  • Waybar"
echo -e "  • Pywal & Swww"
echo -e "  • SDDM and Silent Theme"
echo -e "  • Zsh, Oh-My-Zsh, Powerlevel10k"
echo -e "  • Utilities: Wlogout, Hypridle, Hyprlock, tty-clock, cmatrix, cava, fastfetch"
echo -e "  • Hyprland Dotfiles Directory"
line
read -rp "$(echo -e ${RED}'Do you want to continue? [y/n]: '${RESET})" ans
validate_yesno "$ans" || abort
echo ""

# =====================================================
#  UNINSTALL FUNCTIONS
# =====================================================
remove_wallpapers() {
    remove_msg "Removing Wallpapers..."
    [[ -d ~/Pictures/Wallpapers ]] && rm -rf ~/Pictures/Wallpapers
}

remove_packages() {
    remove_msg "Removing Hyprland, Kitty, Rofi, Thunar..."
    for pkg in hyprland kitty rofi thunar; do
        if pacman -Qi "$pkg" &>/dev/null; then
            sudo pacman -Rns --noconfirm "$pkg"
        fi
    done
}

remove_waybar() {
    remove_msg "Removing Waybar..."
    if command -v yay &>/dev/null && yay -Q waybar &>/dev/null; then
        yay -Rns --noconfirm waybar
    fi
    [[ -d ~/.config/waybar ]] && rm -rf ~/.config/waybar
}

remove_pywal_swww() {
    remove_msg "Removing Pywal and Swww..."
    for pkg in pywal swww; do
        if command -v yay &>/dev/null && yay -Q "$pkg" &>/dev/null; then
            yay -Rns --noconfirm "$pkg"
        fi
    done
}

remove_sddm() {
    remove_msg "Removing SDDM and Silent Theme..."
    if pacman -Qi sddm &>/dev/null; then
        sudo pacman -Rns --noconfirm sddm
    fi
    [[ -d /usr/share/sddm/themes/silent ]] && sudo rm -rf /usr/share/sddm/themes/silent
}

remove_utilities() {
    remove_msg "Removing Utilities..."
    for pkg in wlogout hyprlock hypridle tty-clock cmatrix cava fastfetch; do
        if command -v yay &>/dev/null && yay -Q "$pkg" &>/dev/null; then
            yay -Rns --noconfirm "$pkg"
        fi
    done
    [[ -d ~/.config/fastfetch ]] && rm -rf ~/.config/fastfetch
    [[ -f ~/.config/hypr/hypridle.conf ]] && rm -f ~/.config/hypr/hypridle.conf
    [[ -f ~/.config/hypr/hyprlock.conf ]] && rm -f ~/.config/hypr/hyprlock.conf
}

remove_zsh() {
    remove_msg "Removing Zsh, Oh-My-Zsh, Powerlevel10k..."
    if pacman -Qi zsh &>/dev/null; then
        sudo pacman -Rns --noconfirm zsh
    fi
    [[ -f ~/.zshrc ]] && rm -f ~/.zshrc
    [[ -f ~/.zsh_history ]] && rm -f ~/.zsh_history
    [[ -d ~/.oh-my-zsh ]] && rm -rf ~/.oh-my-zsh
    [[ -f ~/.p10k.zsh ]] && rm -f ~/.p10k.zsh
    [[ -f ~/.shell.pre-oh-my-zsh ]] && rm -f ~/.shell.pre-oh-my-zsh
}

remove_dotfiles_dir() {
    remove_msg "Removing Dotfiles folder..."
    [[ -d ~/Dotfiles ]] && rm -rf ~/Dotfiles
}

# =====================================================
#  EXECUTE UNINSTALLATION
# =====================================================
remove_wallpapers
remove_packages
remove_waybar
remove_pywal_swww
remove_sddm
remove_utilities
remove_zsh
remove_dotfiles_dir

# =====================================================
#  FINAL STATUS & REBOOT PROMPT
# =====================================================
line
echo -e "${GREEN}-----------------------------------------${RESET}"
echo -e "${GREEN}       Uninstallation Finished${RESET}"
echo -e "${GREEN}-----------------------------------------${RESET}"
echo ""
read -rp "$(echo -e ${GREEN}'Do you want to reboot now? [y/n]: '${RESET})" ans
validate_yesno "$ans" && sudo reboot

echo -e "${RED}-----------------------------------------${RESET}"
echo -e "${RED}       Reboot Skipped${RESET}"
echo -e "${RED}-----------------------------------------${RESET}"
exit 0

