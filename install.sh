#!/bin/bash

# =====================================================
#      Sparsha's Hyprland Dotfiles Installer (v1.1.0)
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
note() { echo -e "${BLUE}[ NOTE ]${RESET} $1"; }
install_msg() { echo -e "${GREEN}[ INSTALL ]${RESET} $1"; }
abort() {
    echo -e "\n${RED}-------------------------------------${RESET}"
    echo -e "${RED}       Installation Script Aborted${RESET}"
    echo -e "${RED}-------------------------------------${RESET}"
    exit 1
}

# =====================================================
# 0. CHECK IF SYSTEM IS ARCH-BASED
# =====================================================
clear
line
note "Checking if your system is Arch-based..."
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
line
echo -e "${GREEN}            Sparsha's${RESET}"
echo -e "${GREEN}                HYPRLAND DOTS${RESET}"
line
echo -e "   ・ Version 1.1.0              ・   2025"
line
sleep 1
echo ""

# =====================================================
# 1. ASK QUESTIONS (COLLECT USER CHOICES)
# =====================================================
line
note "Setup prompts — answer the following:"
sleep 1
echo ""

read -rp "$(echo -e ${GREEN}'[ INSTALL ] Do you want to install Timeshift & create a snapshot? [y/n]: '${RESET})" INSTALL_TIMESHIFT
read -rp "$(echo -e ${GREEN}'[ INSTALL ] Install Yay (AUR helper) if missing? [y/n]: '${RESET})" INSTALL_YAY
read -rp "$(echo -e ${GREEN}'[ INSTALL ] Install Google Chrome, Discord, and Spotify? [y/n]: '${RESET})" INSTALL_APPS
read -rp "$(echo -e ${GREEN}'[ INSTALL ] Install SDDM and Silent Theme? [y/n]: '${RESET})" INSTALL_SDDM
read -rp "$(echo -e ${GREEN}'[ INSTALL ] Install Fastfetch? [y/n]: '${RESET})" INSTALL_FASTFETCH
read -rp "$(echo -e ${GREEN}'[ INSTALL ] Install Zsh, Oh-My-Zsh, and Powerlevel10k? [y/n]: '${RESET})" INSTALL_ZSH
read -rp "$(echo -e ${GREEN}'[ INSTALL ] Install Sparsha’s Hyprland Dotfiles? [y/n]: '${RESET})" INSTALL_DOTFILES
echo ""

# =====================================================
# 2. SUMMARY & CONFIRMATION
# =====================================================
line
note "SUMMARY OF CHOICES"
line
[[ $INSTALL_TIMESHIFT == [Yy]* ]] && echo -e "  • Timeshift ................ ${GREEN}Yes${RESET}" || echo -e "  • Timeshift ................ ${RED}No${RESET}"
[[ $INSTALL_YAY == [Yy]* ]] && echo -e "  • Yay ....................... ${GREEN}Yes${RESET}" || echo -e "  • Yay ....................... ${RED}No${RESET}"
[[ $INSTALL_APPS == [Yy]* ]] && echo -e "  • Chrome / Discord / Spotify ${GREEN}Yes${RESET}" || echo -e "  • Apps ...................... ${RED}No${RESET}"
[[ $INSTALL_SDDM == [Yy]* ]] && echo -e "  • SDDM + Theme .............. ${GREEN}Yes${RESET}" || echo -e "  • SDDM + Theme .............. ${RED}No${RESET}"
[[ $INSTALL_FASTFETCH == [Yy]* ]] && echo -e "  • Fastfetch ................. ${GREEN}Yes${RESET}" || echo -e "  • Fastfetch ................. ${RED}No${RESET}"
[[ $INSTALL_ZSH == [Yy]* ]] && echo -e "  • Zsh + Powerlevel10k ....... ${GREEN}Yes${RESET}" || echo -e "  • Zsh + Powerlevel10k ....... ${RED}No${RESET}"
[[ $INSTALL_DOTFILES == [Yy]* ]] && echo -e "  • Hyprland Dotfiles ......... ${GREEN}Yes${RESET}" || echo -e "  • Hyprland Dotfiles ......... ${RED}No${RESET}"
line
echo ""
read -rp "$(echo -e ${GREEN}'[ CONFIRM ] Proceed with installation? [y/n]: '${RESET})" FINAL_CONFIRM
[[ $FINAL_CONFIRM != [Yy]* ]] && abort
echo ""
sleep 0.5

# =====================================================
# 3. ONE-SHOT INSTALLATION PHASE
# =====================================================

clear
line
echo -e "${GREEN}            Sparsha's${RESET}"
echo -e "${GREEN}                HYPRLAND DOTS${RESET}"
line
echo -e "   ・ Version 1.1.0              ・   2025"
line
sleep 1
echo ""

# --- Timeshift ---
if [[ $INSTALL_TIMESHIFT == [Yy]* ]]; then
    line
    note "Installing Timeshift..."
    sudo pacman -S --noconfirm timeshift || abort
    sudo timeshift --create --comments "Pre-Hyprland Install Snapshot"
    info "Timeshift installed and snapshot created!"
fi

# --- Yay ---
if [[ $INSTALL_YAY == [Yy]* ]]; then
    line
    note "Checking Yay..."
    if ! command -v yay &>/dev/null; then
        sudo pacman -S --needed --noconfirm git base-devel
        git clone https://aur.archlinux.org/yay.git
        cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay
        info "Yay installed successfully!"
    else
        info "Yay found!"
    fi
fi

# --- Apps ---
if [[ $INSTALL_APPS == [Yy]* ]]; then
    line
    note "Installing Google Chrome, Discord, Spotify..."
    yay -S --noconfirm google-chrome spotify || info "AUR apps may have failed."
    sudo pacman -S --noconfirm discord noto-fonts noto-fonts-emoji || info "Discord installation failed."
    info "Applications installed successfully!"
fi

# --- SDDM ---
if [[ $INSTALL_SDDM == [Yy]* ]]; then
    line
    note "Installing SDDM and Silent Theme..."
    sudo pacman -S --noconfirm sddm
    sudo mkdir -p /usr/share/sddm/themes/
    sudo cp -r src/SDDM/silent /usr/share/sddm/themes/
    sudo cp src/SDDM/sddm.conf /etc/sddm.conf
    info "SDDM and Silent theme installed!"
fi

# --- Fastfetch ---
if [[ $INSTALL_FASTFETCH == [Yy]* ]]; then
    line
    note "Installing Fastfetch..."
    yay -S --noconfirm fastfetch
    info "Fastfetch installed!"
fi

# --- Zsh / Powerlevel10k ---
if [[ $INSTALL_ZSH == [Yy]* ]]; then
    line
    note "Installing Zsh, Oh-My-Zsh, and Powerlevel10k..."
    sudo pacman -S --noconfirm zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    info "Zsh + Oh-My-Zsh + Powerlevel10k installed!"
fi

# --- Hyprland Dotfiles ---
if [[ $INSTALL_DOTFILES == [Yy]* ]]; then
    line
    note "Installing Sparsha’s Hyprland Dotfiles..."
    sudo pacman -S --noconfirm hyprland kitty
    yay -S --noconfirm nwg-look rofi waybar pywal swww thunar pavucontrol tty-clock cava cmatrix btop htop hyprlock hypridle wlogout
    yay -S --noconfirm ttf-jetbrainsmono-nerd otf-geist-mono-nerd ttf-nerd-fonts-symbols

    mkdir -p ~/.icons ~/.themes ~/.config ~/Pictures
    cd src/GTK/Graphite-gtk-theme && ./install.sh -d ~/.themes/ -t -c dark -s standard -l --tweaks darker rimless normal
    cd src/GTK/WhiteSur-icon-theme && ./install.sh
    cp -r src/GTK/GTK/Bibata-Modern-Ice ~/.icons
    cp -r src/.config/rofi ~/.config/
    cp -r src/.config/kitty ~/.config/
    cp -r src/.config/hypr ~/.config/
    cp -r src/.config/wlogout ~/.config
    cp -r ../../Wallpapers ~/Pictures/
    info "Hyprland Dotfiles installed successfully!"
fi

# =====================================================
# 4. FINAL STATUS & REBOOT PROMPT
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
