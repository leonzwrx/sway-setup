#!/usr/bin/env bash
#
# _     _____ ___  _   _ _____
#| |   | ____/ _ \| \ | |__  /
#| |   |  _|| | | |  \| | / /
#| |___| |__| |_| | |\  |/ /_
#|_____|_____\___/|_| \_/____|
#
#
# - This script will install Sway on Debian Trixie
# - Start with minimal fresh Debian install (run debian_base_trixie.sh first)
# - Make sure this repo is cloned into $HOME/Downloads
# - After running this script, clone/copy dotfiles to make sure sway/waybar customization gets copied

# Exit immediately if a command exits with a non-zero status
set -e

# Ensure the script is run as the regular user
if [ "$(id -u)" = "0" ]; then
    echo "This script should not be run as root. Please run it as a regular user."
    exit 1
fi

## --- Core Packages and Dependencies ---

echo "Installing Sway core packages and dependencies..."

sudo apt update
sudo apt upgrade -y

# Dependencies from source builds
sudo apt install -y build-essential cmake cmake-extras curl gettext libnotify-bin light meson ninja-build libxcb-util0-dev \
    libxkbcommon-dev libxkbcommon-x11-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-cursor-dev \
    libxcb-xinerama0-dev libstartup-notification0-dev

# Core Sway and related Wayland packages
sudo apt install -y sway waybar swaylock gtklock swayidle swaybg mako-notifier wofi kanshi autotiling azote swappy nwg-look nwg-bar \
    nwg-displays nwg-clipman cliphist grim grimshot slurp wl-clipboard xwayland wayvnc

# Theming and icons
sudo apt install -y qt5ct qt6ct papirus-icon-theme qt-style-kvantum qt-style-kvantum-l10n qt-style-kvantum-themes

## --- Manual Theming Installations ---

echo "Installing Nord-Kvantum theme..."
mkdir -p "$HOME/.config/Kvantum"
# Using a more robust tar command that handles nested directories better
tar -xzvf "$HOME/Downloads/sway-setup/resources/Nord-Kvantum.tar.gz" -C "$HOME/.config/Kvantum"

## --- Pipx Tools ---

echo "Installing Python tools with pipx..."
pipx install rofimoji
pipx install sway-input-config

## --- Optional and Source Installations ---

# Optional: Printing and scanning
# sudo apt install -y cups system-config-printer simple-scan
# sudo systemctl enable cups

# Optional: Bluetooth
# sudo apt install -y bluez blueman
# sudo systemctl enable bluetooth

# Networking
sudo apt install -y network-manager network-manager-gnome wpasupplicant

# More Sway utilities
sudo apt install -y foot ffmpegthumbnailer khal tumbler xsettingsd xdg-desktop-portal-wlr \
    python3-send2trash inotify-tools wlsunset wtype

# Manual source installations (assuming scripts exist in the same directory)
echo "Installing wttrbar from source..."
bash "$HOME/Downloads/sway-setup/scripts/wttrbar.sh"

echo "Installing nwg-wrapper from source..."
bash "$HOME/Downloads/sway-setup/scripts/nwg-wrapper_debian.sh"

echo "Installing sway-systemd from source..."
bash "$HOME/Downloads/sway-setup/scripts/sway-systemd.sh" 

# swayr
cargo install swayr
cargo install cargo-update

# Optional: Rofi-wayland fork
# bash "$HOME/Downloads/sway-setup/scripts/rofi-wayland_debian.sh"


# Install custom systemd user services
# Ensure script has write permissions (optional)
# chmod +w $HOME/.config/systemd/user  # Uncomment if needed
cd "$HOME/Downloads/sway-setup/resources"


# Ensure systemd user directory exists
mkdir -p "$HOME/.config/systemd/user"

# Copy service files with verbose output
cp -v swayidle-inhibit.service "$HOME/.config/systemd/user/"
cp -v swayidle.service "$HOME/.config/systemd/user/"
cp -v waybar.service "$HOME/.config/systemd/user/"
cp -v swayrd.service "$HOME/.config/systemd/user/"

systemctl --user daemon-reload  # Reload systemd
systemctl --user enable waybar.service
systemctl --user enable swayrd.service
systemctl --user enable swayidle.service
systemctl --user enable swayidle-inhibit.service


# Install SDDM Display Manager
sudo apt install --no-install-recommends -y sddm
sudo systemctl enable sddm

# Optional: Uncomment to copy .desktop files
# sudo cp "$HOME/Downloads/sway-setup/resources/"*.desktop /usr/share/applications/

## --- Cleanup ---

echo "Running final cleanup..."
sudo apt autoremove -y

printf "\e[1;32mSway installation complete! Remember to copy your dotfiles and reboot.\e[0m\n"
