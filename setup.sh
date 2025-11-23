#!/bin/bash
set -e

# --- 1. Create ~/.config if it doesn't exist ---
mkdir -p ~/.config

# --- 2. Symlink config folders/files ---
CONFIG_DIR="$(pwd)/.config"

declare -A CONFIG_ITEMS=(
    ["fish"]="$HOME/.config/fish"
    ["fontconfig"]="$HOME/.config/fontconfig"
    ["hypr"]="$HOME/.config/hypr"
    ["kitty"]="$HOME/.config/kitty"
    ["nvim"]="$HOME/.config/nvim"
    ["waybar"]="$HOME/.config/waybar"
    ["ssh"]="$HOME/.ssh"
)

for item in "${!CONFIG_ITEMS[@]}"; do
    src="$CONFIG_DIR/$item"
    dest="${CONFIG_ITEMS[$item]}"
    
    if [ -e "$dest" ]; then
        echo "Backing up existing $dest to $dest.bak"
        mv "$dest" "$dest.bak"
    fi

    echo "Linking $src → $dest"
    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
done

# --- 3. Install Pacman packages ---
if [ -f pkglist.txt ]; then
    echo "Installing Pacman packages..."
    sudo pacman -S --needed - < pkglist.txt
fi

# --- 4. Install AUR packages ---
if [ -f aurlist.txt ]; then
    echo "Installing AUR packages..."
    yay -S --needed - < aurlist.txt
fi


echo "All configs and packages applied successfully!"
