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
add_export "/home 192.168.1.0/255.255.255.0(rw,sync,no_subtree_check,no_root_squash)" 
add_export "/media/mass 192.168.1.0/255.255.255.0(rw,sync,no_subtree_check,no_root_squash)" 
add_export "## -------------------------------" 

sudo sed -i 's/^tcp6/#tcp6/' /etc/netconfig
sudo sed -i 's/^udp6/#udp6/' /etc/netconfig

sudo exportfs -ra
sudo service nfs-kernel-server restart
