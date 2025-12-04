#!/bin/bash

# =====================================================
#      Sparsha's Hyprland Dotfiles Installer (v1.3)
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
note() { echo -e "${BLUE}[ NOTE ]${RESET} $1"; }
install_msg() { echo -e "${GREEN}[ INSTALL ]${RESET} $1"; }
abort() {
    echo -e "\n${RED}-------------------------------------${RESET}"
    echo -e "${RED}       Installation Script Aborted${RESET}"
    echo -e "${RED}-------------------------------------${RESET}"
    exit 1
}

check_internet() {
    ping -c 1 archlinux.org &>/dev/null || {
        echo -e "${RED}[ ERROR ]${RESET} No internet connection detected. Please connect and try again."
        exit 1
    }
}

check_root() {
    if [[ $EUID -eq 0 ]]; then
        echo -e "${RED}[ ERROR ]${RESET} Do not run this script as root. Run as normal user."
        exit 1
    fi
}

validate_yesno() {
    local var="$1"
    case "$var" in
        y|Y) return 0 ;;
        n|N) return 1 ;;
        *) echo -e "${RED}[ ERROR ]${RESET} Invalid input. Please enter y or n."; exit 1 ;;
    esac
}

# =====================================================
#  STARTUP
# =====================================================
clear
check_root
check_internet

echo -e "${CYAN}[SCRIPT]${RESET} Loading environment ..."
sleep 0.3
echo -e "${CYAN}[SCRIPT]${RESET} Loading script ..."
sleep 0.3
echo -e "${CYAN}[SCRIPT]${RESET} Loading commands ..."
sleep 0.5
echo ""

# =====================================================
#  CHECK IF SYSTEM IS ARCH-BASED
# =====================================================
line
note "Checking if your system is Arch-based..."
sleep 0.5

if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    if [[ "$ID" == "arch" || "$ID_LIKE" == *"arch"* ]]; then
        info "Arch-based system detected (${NAME})."
    else
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
line
echo -e "${GREEN}            Sparsha's${RESET}"
echo -e "${GREEN}                HYPRLAND DOTS${RESET}"
line
echo -e " ・ Version 1.3 | ・   2025  "
line
sleep 1
echo ""

# =====================================================
#  YAY / AUR HELPER CHECK
# =====================================================
YAY_INSTALLED=false

if command -v yay &>/dev/null; then
    info "Yay is already installed. Proceeding..."
    YAY_INSTALLED=true
elif command -v paru &>/dev/null; then
    echo -e "${YELLOW}[ NOTE ]${RESET} Paru is installed but this script requires Yay."
    read -rp "$(echo -e ${GREEN}'[ INSTALL ] Do you want to remove Paru and install Yay? This is required for the script to continue. [y/n]: '${RESET})" ans
    if validate_yesno "$ans"; then
        install_msg "Removing Paru..."
        sudo pacman -R --noconfirm paru || abort
        YAY_INSTALLED=false
    else
        abort
    fi
else
    read -rp "$(echo -e ${GREEN}'[ INSTALL ] No AUR helper detected. Do you want to install Yay? This is required. [y/n]: '${RESET})" ans
    if validate_yesno "$ans"; then
        YAY_INSTALLED=false
    else
        abort
    fi
fi

# =====================================================
#  ASK OTHER QUESTIONS
# =====================================================
read -rp "$(echo -e ${GREEN}'[ INSTALL ] Install Timeshift & create a snapshot? [y/n]: '${RESET})" INSTALL_TIMESHIFT
read -rp "$(echo -e ${GREEN}'[ INSTALL ] Install Google Chrome, Discord, and Spotify? [y/n]: '${RESET})" INSTALL_APPS
read -rp "$(echo -e ${GREEN}'[ INSTALL ] Install SDDM and Silent Theme? [y/n]: '${RESET})" INSTALL_SDDM
read -rp "$(echo -e ${GREEN}'[ INSTALL ] Install Fastfetch? [y/n]: '${RESET})" INSTALL_FASTFETCH
read -rp "$(echo -e ${GREEN}'[ INSTALL ] Install Zsh, Oh-My-Zsh, and Powerlevel10k? [y/n]: '${RESET})" INSTALL_ZSH
read -rp "$(echo -e ${GREEN}'[ INSTALL ] Install Neovim and apply config? [y/n]: '${RESET})" INSTALL_NVIM
read -rp "$(echo -e ${GREEN}'[ INSTALL ] Install Sparsha’s Hyprland Dotfiles? [y/n]: '${RESET})" INSTALL_DOTFILES

# =====================================================
#  SUMMARY & CONFIRMATION
# =====================================================
line
note "SUMMARY OF CHOICES"
line
echo -e "  • Yay ...................... ${GREEN}Yes${RESET}"
[[ $INSTALL_TIMESHIFT == [Yy]* ]] && echo -e "  • Timeshift ................. ${GREEN}Yes${RESET}" || echo -e "  • Timeshift ................ ${RED}No${RESET}"
[[ $INSTALL_APPS == [Yy]* ]] && echo -e "  • Google Chrome / Discord / Spotify ${GREEN}Yes${RESET}" || echo -e "  • Apps ...................... ${RED}No${RESET}"
[[ $INSTALL_SDDM == [Yy]* ]] && echo -e "  • SDDM + Theme .............. ${GREEN}Yes${RESET}" || echo -e "  • SDDM + Theme .............. ${RED}No${RESET}"
[[ $INSTALL_FASTFETCH == [Yy]* ]] && echo -e "  • Fastfetch ................. ${GREEN}Yes${RESET}" || echo -e "  • Fastfetch ................. ${RED}No${RESET}"
[[ $INSTALL_ZSH == [Yy]* ]] && echo -e "  • Zsh + Powerlevel10k ....... ${GREEN}Yes${RESET}" || echo -e "  • Zsh + Powerlevel10k ....... ${RED}No${RESET}"
[[ $INSTALL_NVIM == [Yy]* ]] && echo -e "  • Neovim .................... ${GREEN}Yes${RESET}" || echo -e "  • Neovim .................... ${RED}No${RESET}"
[[ $INSTALL_DOTFILES == [Yy]* ]] && echo -e "  • Hyprland Dotfiles ......... ${GREEN}Yes${RESET}" || echo -e "  • Hyprland Dotfiles ......... ${RED}No${RESET}"
line
echo ""

read -rp "$(echo -e ${GREEN}'[ CONFIRM ] Proceed with installation? [y/n]: '${RESET})" FINAL_CONFIRM
if ! validate_yesno "$FINAL_CONFIRM"; then
    abort
fi
echo ""
sleep 0.5

# =====================================================
#  INSTALLATION FUNCTIONS
# =====================================================
install_yay() {
    if ! command -v yay &>/dev/null; then
        line
        note "Installing Yay AUR Helper..."
        ./install-scripts/yay.sh || abort
    else
        info "Yay already installed."
    fi
}

install_timeshift() {
    if [[ $INSTALL_TIMESHIFT == [Yy]* ]]; then
        line
        note "Installing Timeshift..."
        sudo pacman -S --noconfirm timeshift || abort
        sudo timeshift --create --comments "Setup Before Sparsha's Pre-configured Hyprland Dots"
        info "Timeshift installed and snapshot created!"
    fi
}

install_apps() {
    if [[ $INSTALL_APPS == [Yy]* ]]; then
        line
        note "Installing Applications..."
        yay -S --noconfirm google-chrome spotify || info "AUR apps may have failed."
        sudo pacman -S --noconfirm discord noto-fonts noto-fonts-emoji || info "Discord installation failed."
        info "Applications installed successfully!"
    fi
}

install_sddm() {
    if [[ $INSTALL_SDDM == [Yy]* ]]; then
        line
        note "Installing SDDM and Silent Theme..."
        sudo pacman -S --noconfirm sddm
        sudo mkdir -p /usr/share/sddm/themes/
        sudo cp -r src/SDDM/silent /usr/share/sddm/themes/
        sudo cp src/SDDM/sddm.conf /etc/sddm.conf
        info "SDDM and Silent theme installed!"
    fi
}

install_fastfetch() {
    if [[ $INSTALL_FASTFETCH == [Yy]* ]]; then
        line
        note "Installing Fastfetch..."
        yay -S --noconfirm fastfetch
        info "Fastfetch installed!"
    fi
}

install_zsh() {
    if [[ $INSTALL_ZSH == [Yy]* ]]; then
        line
        note "Installing Zsh, Oh-My-Zsh, and Powerlevel10k..."
        sudo pacman -S --noconfirm zsh
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
        cp -r src/.oh-my-zsh ~
        cp -r src/.p10krc ~
        cp -r src/.zshrc ~
        info "Zsh + Oh-My-Zsh + Powerlevel10k installed!"
    fi
}

install_nvim() {
    if [[ $INSTALL_NVIM == [Yy]* ]]; then
        line
        note "Installing Neovim and applying config..."
        sudo pacman -S --noconfirm neovim || abort
        mkdir -p ~/.config/nvim
        cp -r src/.config/nvim/* ~/.config/nvim/
        info "Neovim installed and config applied!"
    fi
}

install_dotfiles() {
    if [[ $INSTALL_DOTFILES == [Yy]* ]]; then
        line
        note "Installing Sparsha’s Hyprland Dotfiles..."
        ./install-scripts/base.sh
        ./install-scripts/packages.sh
        ./install-scripts/gtk.sh
        ./install-scripts/wallpapers.sh
        ./install-scripts/configs.sh
        info "Hyprland Dotfiles installed successfully!"
    fi
}

# =====================================================
#  EXECUTE INSTALLATION
# =====================================================
clear
line
echo -e "${GREEN}            Sparsha's${RESET}"
echo -e "${GREEN}                HYPRLAND DOTS${RESET}"
line
echo -e "   ・ Version 1.3              ・   2025"
line
sleep 1
echo ""

install_yay
install_timeshift
install_apps
install_sddm
install_fastfetch
install_zsh
install_nvim
install_dotfiles

# =====================================================
#  FINAL STATUS & REBOOT PROMPT
# =====================================================
line
read -rp "$(echo -e ${GREEN}'[ INSTALL ] Installation completed. Do you want to reboot now? [y/n]: '${RESET})" ans
echo ""
if [[ $ans == [Yy]* ]]; then
    echo -e "${GREEN}-----------------------------------------${RESET}"
    echo -e "${GREEN}       Installation Script Finished${RESET}"
    echo -e "${GREEN}-----------------------------------------${RESET}"
    sleep 2
    sudo reboot
else
    echo -e "${RED}-----------------------------------------${RESET}"
    echo -e "${RED}       Installation Script Ended${RESET}"
    echo -e "${RED}-----------------------------------------${RESET}"
    exit 0
fi

