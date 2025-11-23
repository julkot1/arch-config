#!/bin/bash
set -euo pipefail

# --- 1. Ensure ~/.config exists ---
mkdir -p "$HOME/.config"

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

backup_item() {
    local dest="$1"

    if [ -e "$dest" ]; then
        local backup="${dest}.bak-$(date +%Y%m%d-%H%M%S)"
        echo "Backing up existing $dest → $backup"
        mv "$dest" "$backup"
    fi
}

# --- 2. Copy configs ---
for item in "${!CONFIG_ITEMS[@]}"; do
    src="$CONFIG_DIR/$item"
    dest="${CONFIG_ITEMS[$item]}"

    if [ ! -e "$src" ]; then
        echo " WARNING: $src does not exist. Skipping."
        continue
    fi

    echo "Processing $item..."

    backup_item "$dest"

    mkdir -p "$(dirname "$dest")"

    echo "Copying $src → $dest"
    cp -r "$src" "$dest"
done

# --- 3. Install Pacman packages ---
if [ -f pkglist.txt ]; then
    echo "Installing Pacman packages..."
    sudo pacman -Syu --needed --noconfirm - < pkglist.txt
fi

# --- 4. Install AUR packages ---
if [ -f aurlist.txt ]; then
    echo "Installing AUR packages via yay..."
    yay -S --needed --noconfirm - < aurlist.txt
fi

echo "🎉 All configs and packages applied successfully!"
