#!/usr/bin/env bash

COLOR_BIRed='\e[1;91m'
COLOR_BIGreen='\e[1;92m'

# This is taken directly from raspi-config, which doesn't yet accept command line arguments
# https://github.com/asb/raspi-config/blob/master/raspi-config

# keep us from running this more than once
if [ -e /pi-install-expanded ]
then
    echo -e "${COLOR_BIGreen}Rootfs already expanded.  Done!${COLOR_off}"
    exit 0
fi


if ! [ -h /dev/root ]
then
    echo -e "${COLOR_BIRed}/dev/root does not exist or is not a symlink. Don't know how to expand${COLOR_off}" > /dev/stderr 
    exit 1
fi

ROOT_PART=$(readlink /dev/root)
PART_NUM=${ROOT_PART#mmcblk0p}
if [ "$PART_NUM" = "$ROOT_PART" ]
then
    echo -e "${COLOR_BIRed}/dev/root is not an SD card. Don't know how to expand.${COLOR_off}" > /dev/stderr 
    exit 1
fi

# NOTE: the NOOBS partition layout confuses parted. For now, let's only 
# agree to work with a sufficiently simple partition layout
if [ "$PART_NUM" -ne 2 ]
then
    echo -e "${COLOR_BIRed}Your partition layout is not currently supported by this tool. You are probably using NOOBS, in which case your root filesystem is already expanded anyway.${COLOR_off}" > /dev/stderr 
    exit 1
fi

LAST_PART_NUM=$(parted /dev/mmcblk0 -ms unit s p | tail -n 1 | cut -f 1 -d:)

if [ "$LAST_PART_NUM" != "$PART_NUM" ]
then
    echo -e "${COLOR_BIRed}/dev/root is not the last partition. Don't know how to expand.${COLOR_off}" > /dev/stderr 
    exit 1
fi

# Get the starting offset of the root partition
PART_START=$(parted /dev/mmcblk0 -ms unit s p | grep "^${PART_NUM}" | cut -f 2 -d:)
[ "$PART_START" ] || exit  1
# Return value will likely be error for fdisk as it fails to reload the
# partition table because the root fs is mounted
fdisk /dev/mmcblk0 <<EOF
p
d
$PART_NUM
n
p
$PART_NUM
$PART_START

p
w
EOF


  # now set up an init.d script
cat <<\EOF > /etc/init.d/resize2fs_once &&
#!/bin/sh
### BEGIN INIT INFO
# Provides:          resize2fs_once
# Required-Start:
# Required-Stop:
# Default-Start: 2 3 4 5 S
# Default-Stop:
# Short-Description: Resize the root filesystem to fill partition
# Description:
### END INIT INFO

. /lib/lsb/init-functions

case "$1" in
  start)
    log_daemon_msg "Starting resize2fs_once" &&
    resize2fs /dev/root &&
    rm /etc/init.d/resize2fs_once &&
    update-rc.d resize2fs_once remove &&
    log_end_msg $?
    ;;
  *)
    echo "Usage: $0 start" >&2
    exit 3
    ;;
esac
EOF

chmod +x /etc/init.d/resize2fs_once &&
update-rc.d resize2fs_once defaults &&
echo -e "${COLOR_BIGreen}Root partition has been resized.\nThe filesystem will be enlarged upon the next reboot${COLOR_off}"
sudo touch /pi-install-expanded 



read -t 5 -p "Would you like to reboot now? [Y/n] " reboot_now
reboot_now=${reboot_now:-yes}
if [[ "$(echo $reboot_now | grep -i  ^y )" ]]
then
    echo -e "${COLOR_BIGreen}Rebooting NOW.${COLOR_off}"
    sudo shutdown -r now
else
    echo "Be sure to reboot for filesystem changes to take effect."  
fi

