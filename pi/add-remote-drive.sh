#!/usr/bin/env bash
sagi rpcbind nfs-common
sudo mkdir -p /media/remote
echo "## created on $(date) by add-remote-drive.sh" | sudo tee --append /etc/fstab
echo "ray:/media/mass    /media/remote   nfs    rsize=8192,wsize=8192,timeo=14,intr" | sudo tee --append /etc/fstab
sudo mount -a
