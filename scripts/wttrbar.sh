#!/bin/bash

# Define the repository URL and the user's preferred source build directory
repo_url="https://github.com/bjesus/wttrbar.git"
source_dir="$HOME/SourceBuilds"
clone_dir="$source_dir/wttrbar"

# Check if Rust and Cargo are installed
if ! command -v cargo &> /dev/null; then
    echo "Error: Cargo is not installed. Please install Rust and Cargo first."
    exit 1
fi

# Create the source build directory if it doesn't exist
if [ ! -d "$source_dir" ]; then
    echo "Creating directory: $source_dir"
    mkdir -p "$source_dir"
fi

# Remove the directory if it already exists to prevent git clone from failing
if [ -d "$clone_dir" ]; then
    echo "Removing existing directory: $clone_dir"
    rm -rf "$clone_dir"
fi

# Clone the repository
echo "Cloning wttrbar repository into $clone_dir..."
if git clone "$repo_url" "$clone_dir"; then
    echo "Repository cloned successfully."
else
    echo "Error: Failed to clone the repository. Check your internet connection or repository URL."
    exit 1
fi

# Build the project in release mode
echo "Building wttrbar..."
cd "$clone_dir" || exit
if cargo build --release; then
    echo "Build successful."
else
    echo "Error: Failed to build wttrbar."
    exit 1
fi

# Move the compiled binary to /usr/local/bin
echo "Installing wttrbar to /usr/local/bin..."
sudo mv "target/release/wttrbar" "/usr/local/bin/"

echo "wttrbar installed successfully from source in $clone_dir!"
echo "You can now use 'wttrbar' in your Waybar configuration."
