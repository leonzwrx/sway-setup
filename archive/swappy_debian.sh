#!/bin/bash

# Define build directory
BUILD_DIR="$HOME/SourceBuilds/swappy"

# Check if SourceBuilds directory exists
if [ ! -d "$BUILD_DIR" ]; then
  echo "Source directory '$BUILD_DIR' not found. Creating it..."
  mkdir -p "$BUILD_DIR"
fi

# Install build dependencies
echo "Installing build dependencies..."
sudo apt install -y git meson build-essential libgtk-3-dev libcairo2-dev libgirepository1.0-dev

# Clone source code
git clone https://github.com/jtheoof/swappy "$BUILD_DIR"

# Build and install swappy
cd "$BUILD_DIR"
meson setup build
cd build
ninja
sudo ninja install

echo "swappy installation complete!"
