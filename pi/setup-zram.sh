#!/usr/bin/env bash

# http://gionn.net/2012/03/11/zram-on-debian-ubuntu-for-memory-overcommitment/
# http://www.reddit.com/r/sysadmin/comments/15kmby/using_compressed_ram_for_memoryovercommit_on_linux/

echo "Installing zram"

# formerly https://raw.github.com/gionn/etc/master/init.d/zram -O /etc/init.d/zram
sudo wget https://raw.github.com/swirepe/personalscripts/master/pi/zram -O /etc/init.d/zram

sudo chmod +x /etc/init.d/zram
sudo update-rc.d zram defaults
	
echo "Starting zram"
sudo /etc/init.d/zram start

dmesg | grep zram
cat /proc/swaps

