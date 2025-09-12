#! /bin/bash

sudo apt install -y python3-i3ipc

mkdir -p ~/SourceBuilds
cd ~/SourceBuilds
git clone https://github.com/nwg-piotr/autotiling.git
cd autotiling/autotiling
chmod +x main.py
sudo mv main.py /usr/bin/autotiling
