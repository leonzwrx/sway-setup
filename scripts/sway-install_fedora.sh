#!/usr/bin/env bash
#
# _     _____ ___  _   _ _____
#| |   | ____/ _ \| \ | |__  /
#| |   |  _|| | | |  \| | / /
#| |___| |__| |_| | |\  |/ /_
#|_____|_____\___/|_| \_/____|
#
#
# - This script will add some customization to a stock Fedora Sway spin
# - Start with stock Fedora Sway spin with mostly defaults
# - Make sure sway is working and functional
# - Make sure this repo is cloned into $HOME/Downloads
# - After running this script, clone/copy dotfiles to make sure sway/waybar customization gets copied

set -e

# Ensure the script is run as the regular user
if [ "$(id -u)" = "0" ]; then
    echo "This script should not be run as root. Please run it as a regular user."
    exit 1
fi

# Set the username variable
username=$(whoami)

##################################
# Install sway-related packages
##################################

prepare_environment() {
    cd $HOME/Downloads/sway-setup/scripts
    chmod +x *.sh
}

install_sway_packages() {
  # pipx packages (not available in standard repos):
    sudo dnf -y install pipx
    pipx install sway-input-config
    
    # Autotiling
    pipx install autotiling

    # rofimoji using pipx because the standard repo has a package that needs rofi-wayland but sticking with regular rofi
    pipx install rofimoji

    # Networking and bluetooth
    sudo dnf install -y blueman nm-connection-editor NetworkManager-tui network-manager-applet nm-connection-editor-desktop NetworkManager 

    # Clipboard, background and screenshot tools
    sudo dnf install -y grim slurp wl-clipboard swappy azote

    # Theming
    sudo dnf install -y qt5-qtstyleplugins qt5ct qt6ct papirus-icon-theme kvantum

    #Nord-Kvantum theme
    echo "Installing Nord-Kvantum theme..."
    mkdir -p "$HOME/.config/Kvantum"
    # Using a more robust tar command that handles nested directories better
    tar -xzvf "$HOME/Downloads/sway-setup/resources/Nord-Kvantum.tar.gz" -C "$HOME/.config/Kvantum"

    # More Sway utilities and related Wayland packages
    sudo dnf install -y rofi foot ffmpegthumbnailer jq khal mako tumbler waybar xsettingsd xdg-desktop-portal-wlr \
    python3-send2trash inotify-tools kanshi mako wofi Xwayland wlsunset wtype

    #OPTIONAL Emoji selector - has a rofi-wayland requirement. 
    #Installing using pipx instead
    #sudo dnf install -y rofimoji

    #nwg-piotr packages from main reposs
    sudo dnf install -y nwg-bar nwg-wrapper

    # Optional: rofi-wayland fork in case standard package does not work
    # sudo dnf install -y rofi-wayland
}

install_manual_sway_packages() {
    # wttrbar
    echo "Installing wttrbar from source..."
    bash "$HOME/Downloads/sway-setup/scripts/wttrbar.sh"
    
    
    # nwg-piotr packages from copr not found in main repos
    sudo dnf -y copr enable tofik/nwg-shell
    sudo dnf -y update
    sudo dnf install -y nwg-displays nwg-look

    #gtklock
    sudo dnf -y copr enable mochaa/gtklock
    sudo dnf -y update
    sudo dnf -y install gtklock


    #nwg-clipman from source (not available in standard repos)
    mkdir -p  $HOME/SourceBuilds && cd $HOME/SourceBuilds
    git clone https://github.com/nwg-piotr/nwg-clipman.git
    cd nwg-clipman/
    sudo ./install.sh 

    # swayr
    cargo install swayr
    cargo install cargo-update

    # cliphist
    go install go.senan.xyz/cliphist@latest
}

install_custom_systemd_services() {
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

    echo "Installing sway-systemd from source..."
    bash "$HOME/Downloads/sway-setup/scripts/sway-systemd.sh" 



 }

final_cleanup() {
    sudo dnf autoremove
}

main() {
    prepare_environment
    install_sway_packages
    install_manual_sway_packages
    install_custom_systemd_services
    final_cleanup

    printf "\e[1;32mYou can now reboot! Thank you.\e[0m\n"
}

main
