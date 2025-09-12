 #!/bin/sh

sudo apt install -y python3

mkdir -p ~/SourceBuilds
cd ~/SourceBuilds
git clone https://github.com/Sunderland93/sway-input-config.git
cd sway-input-config && sudo python3 setup.py install
