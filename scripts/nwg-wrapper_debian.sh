#! /bin/bash

mkdir -p ~/SourceBuilds
cd ~/SourceBuilds

git clone https://github.com/nwg-piotr/nwg-wrapper.git
cd nwg-wrapper
sudo python3 setup.py install --optimize=1
