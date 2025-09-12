#!/bin/bash

# Download URL for nwg-bar v0.1.6 (modify if needed)
DOWNLOAD_URL="https://github.com/nwg-piotr/nwg-bar/releases/download/v0.1.6/nwg-bar-v0.1.6_x86_64.tar.gz"

# Temporary directory for extraction
TMP_DIR=$(mktemp -d)

# Check if `wget` is installed
if ! command -v wget &> /dev/null; then
  echo "Error: wget is not installed. Please install it first."
  exit 1
fi

# Download the archive
echo "Downloading nwg-bar..."
wget -q -O "$TMP_DIR/nwg-bar.tar.gz" "$DOWNLOAD_URL" || { echo "Download failed!"; exit 1; }

# Extract the archive
echo "Extracting nwg-bar..."
tar -xzf "$TMP_DIR/nwg-bar.tar.gz" -C "$TMP_DIR" || { echo "Extraction failed!"; exit 1; }

# Make nwg-bar executable
chmod +x "$TMP_DIR/bin/nwg-bar"

# Copy nwg-bar to /usr/bin (requires root privileges)
echo "Copying nwg-bar to /usr/bin..."
sudo cp -f "$TMP_DIR/bin/nwg-bar" /usr/bin/ || { echo "Copying failed (requires root privileges)!"; exit 1; }

# Copy entire config directory (requires root privileges)
echo "Copying config directory..."
sudo cp -rf "$TMP_DIR/config" /usr/share/nwg-bar/ || { echo "Copying config directory failed (requires root privileges)!"; exit 1; }

# Copy images directory (requires root privileges)
echo "Copying images directory..."
sudo cp -rf "$TMP_DIR/images" /usr/share/nwg-bar/ || { echo "Copying images directory failed (requires root privileges)!"; exit 1; }

# Clean up temporary directory
echo "Cleaning up..."
rm -rf "$TMP_DIR"

echo "nwg-bar installation complete!"
