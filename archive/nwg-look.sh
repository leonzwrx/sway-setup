#!/bin/sh

# Define variable to store latest version tag
latest=$(curl -sL https://api.github.com/repos/nwg-piotr/nwg-look/releases/latest | jq -r '.tag_name')

# Download archive for latest version
source_dir="$HOME/SourceBuilds"  # Define source directory
mkdir -p "$source_dir"  # Create SourceBuilds directory if it doesn't exist

cd "$source_dir"
wget https://github.com/nwg-piotr/nwg-look/archive/refs/tags/"$latest".zip

# Unzip archive
unzip "$latest".zip

# Extract directory name (assuming consistent naming)
directory_name="nwg-look-${latest#v}"

# Change directory to extracted folder (within source_dir)
cd "$directory_name"

# Build nwg-look using Go
sudo go build -o /usr/bin/nwg-look

#Copy .desktop file and icon
cd stuff
sudo cp nwg-look.desktop /usr/share/applications
sudo cp nwg-look.svg /usr/share/pixmaps

# Clean up downloaded files (within source_dir)
cd ..
rm -rf "$directory_name"
rm "$latest".zip
