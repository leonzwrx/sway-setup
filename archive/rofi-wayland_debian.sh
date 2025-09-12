#!/usr/bin/env bash

sudo apt install -y bison flex libcairo2-dev libpango1.0-dev libxkbcommon-dev \
  libmpdclient-dev libnl-3-dev libasound2-dev \
  libxcb-util-dev libxcb-xkb-dev libxkbcommon-x11-dev libxcb-ewmh-dev \
  libxcb-icccm4-dev libxcb-randr0-dev libxcb-cursor0 libxcb-cursor-dev \
  check libxcb-xinerama0-dev libstartup-notification0-dev libwayland-dev wayland-protocols

mkdir -p ~/SourceBuilds
cd ~/SourceBuilds

git clone https://github.com/lbonn/rofi.git
cd rofi
meson setup build && ninja -C build
sudo ninja -C build install


