#! /bin/bash

mkdir -p ~/SourceBuilds
cd ~/SourceBuilds
git clone https://github.com/nwg-piotr/azote.git
cd azote
sudo python3 setup.py install
cd dist
#Copy .desktop file and icon
sudo cp azote.desktop /usr/share/applications
sudo cp azote.svg /usr/share/pixmaps
