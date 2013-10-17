#!/usr/bin/env bash
## https://help.ubuntu.com/community/SettingUpNFSHowTo
sagi rpcbind nfs-kernel-server

function add_to_file {
    STRING="$1"
    FILE="$2"
    
    echo "$STRING" | sudo tee --append $FILE
}

function add_export {
    add_to_file "$1" /etc/exports
}

add_export "## -------------------------------" 
add_export "## added on $(date) by setup-nfs.sh" 
add_export "/home 192.168.1.0/255.255.255.0(rw,sync,no_subtree_check)" 
add_export "/media/mass 192.168.1.0/255.255.255.0(rw,sync,no_subtree_check)" 
add_export "## -------------------------------" 

sudo exportfs -ra

sudo update-rc.d rpcbind enable 
sudo update-rc.d nfs-common enable
sudo service rpcbind restart
sudo service nfs-kernel-server restart
