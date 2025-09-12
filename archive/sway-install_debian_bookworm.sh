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
# - Start with minimal fresh Debian install (run debian_base_bookworm.sh first)
# - Make sure this repo is cloned into $userhome/Downloads
# - After running this script, clone/copy dotfiles to make sure sway/waybar customization gets copied

# Ensure the script is run as the regular user
if [ "$(id -u)" = "0" ]; then
    echo "This script should not be run as root. Please run it as a regular user."
    exit 1
fi

# Set the username variable
username=$(whoami)
userhome="/home/$username"

# Proceed regardless (assuming scripts are already present)
cd $userhome/Downloads/linux-setup-scripts
# Make scripts executable
chmod +x *.sh
  
# Dependencies that may or may not have been installed as a part of base install
sudo apt install -y build-essential cmake cmake-extras curl gettext libnotify-bin light meson ninja-build libxcb-util0-dev libxkbcommon-dev libxkbcommon-x11-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-cursor-dev libxcb-xinerama0-dev libstartup-notification0-dev

# Sway installation for Debian Bookworm
sudo apt install -y sway waybar swaylock swayidle swaybg mako-notifier wofi kanshi

# Clipboard and screenshot tools
sudo apt install -y clipman grim grimshot slurp wl-clipboard


# Theming
sudo apt install -y qt5ct qt6ct papirus-icon-theme qt5-style-kvantum qt5-style-kvantum-l10n qt5-style-kvantum-themes
#Install Nord-Kvantum theme
mkdir -p $userhome/.config/Kvantum
tar -xzvf $userhome/Downloads/linux-setup-scripts/resources/Nord-Kvantum.tar.gz -C $userhome/.config/Kvantum

#Use pipx to install rofimoji to a local virtual environment
pipx install rofimoji

#Use pipx to install sway-input-config
pipx install sway-input-config
# [OPTIONAL if pipx doesn't work] sway-input-configurator from source - not currently available in Debian's repos
# bash $userhome/Downloads/linux-setup-scripts/sway-input-configurator_debian.sh

pipx install autotiling
#  [OPTIONAL if pipx doesn't work] Autotiling from source - not currently available in Debian's repos
# bash $userhome/Downloads/linux-setup-scripts/autotiling_debian.sh

# [OPTIONAL] Printing and scanning - Comment out if not needed
sudo apt install -y cups system-config-printer simple-scan
sudo systemctl enable cups

# [OPTIONAL] Bluetooth - Comment out if not needed
sudo apt install -y bluez blueman
sudo systemctl enable bluetooth

# Networking
sudo apt install -y network-manager network-manager-gnome wpasupplicant

# More Sway tools and utilities
sudo apt install -y foot ffmpegthumbnailer khal tumbler xsettingsd xdg-desktop-portal-wlr python3-send2trash inotify-tools wlsunset wtype

## MANUAL SOURCE INSTALL

# Azote for backgrounds - Manually moved .desktop and icon from azote/dist folder
bash $userhome/Downloads/linux-setup-scripts/azote.sh

# wttrbar - Could not get the script to dynamically download the latest version. This script downloads a specific version (can change in the script).
# Alternative solution, download the binary from https://github.com/bjesus/wttrbar/releases/latest and place into /usr/bin manually
bash $userhome/Downloads/linux-setup-scripts/wttrbar.sh

# Swappy - not currently available in Debian's repos 
bash $userhome/Downloads/linux-setup-scripts/swappy_debian.sh

# nwg-look - gtk3 theming for Wayland
bash $userhome/Downloads/linux-setup-scripts/nwg-look.sh

# nwg-bar - not currently available for Bookworm stable - copying files manually using nwg-bar_debian.sh
bash $userhome/Downloads/linux-setup-scripts/nwg-bar_debian.sh

# nwg-displays - not currently available for Bookworm stable - installing from source using nwg-displays.sh
bash $userhome/Downloads/linux-setup-scripts/nwg-displays.sh

# nwg-wrapper- not currently available for Bookworm stable - installing from source using nwg-wrapper.sh
bash $userhome/Downloads/linux-setup-scripts/nwg-displays.sh

# sway-systemd not currently available for Bookworm stable - installing from source using sway-systemd.sh
# allows sway to run in a systemd environment
bash $userhome/Downloads/linux-setup-scripts/sway-systemd.sh

# Rofi-wayland fork - not currently available in Debian's repos
bash $userhome/Downloads/linux-setup-scripts/rofi-wayland_debian.sh

#[OPTIONAL] Uncomment to copy .desktop files for manually installed applications if they are missing
#sudo cp $userhome/Downloads/linux-setup-scripts/resources/*.desktop /usr/share/applications

#Install SDDM Console Display Manager - Comment out if a different Display Manager is used
sudo apt install --no-install-recommends -y sddm
sudo systemctl enable sddm

# Cleanup
sudo apt autoremove

printf "\e[1;32mYou can now reboot! DO NOT FORGET TO COPY dotfiles. Thanks you.\e[0m\n"
