#!/usr/bin/env bash

# ramlog keeps the flash card alive for a little bit longer
# http://people.virginia.edu/~ll2bf/docs/nix/rpi_server.html
# http://www.tremende.com/ramlog/index.htm

echo "Setting up ramlog to save your sd card."
sudo apt-get install lsof

# formerly http://www.tremende.com/ramlog/download/ramlog_2.0.0_all.deb
wget https://raw.github.com/swirepe/personalscripts/master/pi/ramlog_2.0.0_all.deb
sudo dpkg -i ramlog_2.0.0_all.deb

echo "TMPFS_RAMFS_SIZE=40m" | sudo tee /etc/default/ramlog

echo "Reboot required."
