#!/bin/bash

# Install gtk
yay -S gtk gtk3 gtk4

# Make directories
sudo mkdir -p ~/.themes
sudo mkdir -p ~/.icons

# Install Graphite gtk theme
cd src/GTK/Graphite-gtk-theme
./install.sh -d ~/.themes/ -t -c dark -s standard -l --tweaks darker rimless normal

# Install WhiteSur icon theme
cd src/GTK/WhiteSur-icon-theme
./install.sh

# Install Bibata Modern Ice cursor theme
sudo cp -r src/GTK/Bibata-Modern-Ice ~/.icons


# Apply GTK Theme
gsettings set org.gnome.desktop.interface gtk-theme "Graphite" 
gsettings set org.gnome.desktop.wm.preferences theme "Graphite"

# Apply Icon Theme
gsettings set org.gnome.desktop.interface icon-theme "WhiteSur"

# Apply Cursor theme
gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice"

