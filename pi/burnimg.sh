#!/usr/bin/env bash

#  cd ~/src
#  df -h
#  sudo umount /dev/mmcblk0p1
#  df -h
#  sudo dd bs=4M 2013-07-26-wheezy-raspbian.img of=/dev/mmcblk0



cd ~/src
df -h
PARTS="$(df -h | grep mccblk0 )"
while [[ "$PARTS" ]]
do
		PART="$(df -h | grep -o /dev/mccblk0p. )"
    sudo umount $PART

    PARTS="$(df -h | grep mccblk0 )"
done
df -h
echo " sudo dd bs=4M if=2013-07-26-wheezy-raspbian.img of=/dev/mmcblk0 "
