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
# - Verify internet connection
# - Make sure sway is working and functional
# - Make sure this repo is cloned into ~/Downloads
# - After running this script, clone/copy dotfiles to make sure sway/waybar customization gets copied

set -e

# Ensure the script is run as the regular user
if [ "$(id -u)" = "0" ]; then
    echo "This script should not be run as root. Please run it as a regular user."
    exit 1
fi

# Set the username variable
username=$(whoami)
userhome="/home/$username"

##################################
# Install sway-related packages
##################################

prepare_environment() {
    cd $userhome/Downloads/sway-setup/scripts
    chmod +x *.sh
}

install_sway_packages() {
    # Sway input configurator using pip:
    sudo pip install sway-input-config

    # Autotiling
    sudo pip install autotiling

    # Install nwg-look - UPDATE
    if [ -f $userhome/Downloads/sway-setup/scripts/nwg-look.sh ]; then
        bash $userhome/Downloads/sway-setup/scripts/nwg-look.sh
    fi

    # Networking and bluetooth
    sudo dnf install -y blueman nm-connection-editor NetworkManager-tui network-manager-applet nm-connection-editor-desktop NetworkManager 

    # Clipboard and screenshot tools
    sudo dnf install -y grim slurp wl-clipboard swappy

    # Theming
    sudo dnf install -y qt5-qtstyleplugins qt5ct qt6ct papirus-icon-theme kvantum
    #Install Nord-Kvantum theme
    mkdir -p $userhome/.config/Kvantum
    tar -xzf "$userhome/Downloads/sway-setup/resources/Nord-Kvantum.tar.gz" -C $userhome/.config/Kvantum

    # More Sway utilities
    sudo dnf install -y rofi-wayland foot ffmpegthumbnailer jq khal mako tumbler waybar xsettingsd xdg-desktop-portal-wlr python3-send2trash inotify-tools kanshi

    # Emoji selector - can also be installed with pip install rofimoji
    sudo dnf install -y rofimoji
}

install_manual_sway_packages() {
  # wttrbar - Could not get the script to dynamically download the latest version. This script downloads a specific version (can change in the script).
    # Alternative solution, download the binary from https://github.com/bjesus/wttrbar/releases/latest and place into /usr/bin manually
    cd $userhome/Downloads/sway-setup/scripts
    sudo bash wttrbar.sh

    # Azote for backgrounds - Manually moved .desktop and icon from azote/dist folder
    cd $userhome/SourceBuilds
    git clone https://github.com/nwg-piotr/azote.git
    cd azote
    sudo python3 setup.py install

    # swayr
    cargo install swayr
    cargo install cargo-update

    # nwg-bar - could not build from source but it's available as Fedora Copr
    sudo dnf -y copr enable tofik/nwg-shell
    sudo dnf update
    sudo dnf install -y nwg-bar nwg-displays
    sudo dnf -y copr disable tofik/nwg-shell

    # gtklock - not available in Fedora's repos
    sudo dnf -y copr enable mochaa/gtklock
    sudo dnf update
    sudo dnf install -y gtklock gtk-session-lock
    sudo dnf -y corp disable mochaa/gtklock

    #Clipboard stuff - cliphist and nwg-clipman (GUI tool)
    go install go.senan.xyz/cliphist@latest
    
    cd $userhome/SourceBuilds
    git clone https://github.com/nwg-piotr/nwg-clipman
    cd nwg-clipman
    sudo bash install.sh

    #[OPTIONAL] Uncomment to copy .desktop files for manually installed applications
    #sudo cp $userhome/Downloads/sway-setup/scripts/resources/*.desktop /usr/share/applications

}

install_custom_systemd_services() {
    # Install custom systemd user services
    # Ensure script has write permissions (optional)
    # chmod +w $userhome/.config/systemd/user  # Uncomment if needed
    cd "$userhome/Downloads/sway-setup/resources"  # Double quotes for safety
    
    # Check if directory exists (avoid overwriting data accidentally)
    if [[ -d "$userhome/.config/systemd/user" ]]; then
    # Copy service files with verbose output
      cp -v swayidle-inhibit.service "$userhome/.config/systemd/user"
      cp -v swayidle.service "$userhome/.config/systemd/user"
      cp -v waybar.service "$userhome/.config/systemd/user"
      cp -v swayrd "$userhome/.config/systemd/user"
    else
      echo "Warning: Directory ~/.config/systemd/user does not exist. Skipping copy."
    fi

sudo systemctl daemon-reload  # Reload systemd
systemctl --user enable waybar.service --now
systemctl --user enable swayrd.service --now
systemctl --user enable swayidle.service --now
systemctl --user enable swayidle-inhibit.service --now


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
