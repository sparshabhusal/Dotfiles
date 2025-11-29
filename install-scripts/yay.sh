#!/bin/bash

# Install yay
cd ~
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Remove the unnecessary yay folder
sudo rm -rf ~/yay
