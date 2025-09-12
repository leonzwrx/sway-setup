#!/bin/sh

# Download archive for latest version
source_dir="$HOME/SourceBuilds"  # Define source directory
mkdir -p "$source_dir"  # Create SourceBuilds directory if it doesn't exist
cd $source_dir

#Clone the repo
git clone https://github.com/alebastr/sway-systemd.git
cd sway-systemd
#install
meson build --prefix=/usr -Dautoload-configs=autostart,cgroups,locale1
sudo ninja -C build install
