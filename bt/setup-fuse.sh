#!/usr/bin/env bash
sagi sshfs sshpass
sudo usermod -aG fuse $(whoami)
mkdir ~/snake_torrents
sshpass -p 'snake' sshfs root@snake:/usb/sda1/torrents/torrentwatch/ ~/snake_torrents


echo "Adding to crontab."
crontab -l | { cat - ; echo -e "## Added on $(date) by setup-fuse.sh\n@reboot sshpass -p 'snake' sshfs root@snake:/usb/sda1/torrents/torrentwatch/ ~/snake_torrents" ; } | crontab -e
