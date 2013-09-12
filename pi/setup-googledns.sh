#!/usr/bin/env bash

# Most of this information from
# https://developers.google.com/speed/public-dns/docs/using
# But you knew that.

echo "Adding google's dns servers"

if [[ ! "$(which traceroute)" ]]
then
    echo "Installing traceroute"
    sudo apt-get install -y traceroute
fi

if [[ "$(traceroute -n -w 2 -q 2 -m 30 8.8.8.8 | tail -n 1 | grep 8.8.8.8)" ]]
then
    echo "Google dns found. Adding to config files."
    if [ -e /etc/resolv.conf ]
    then
        echo "Adding to /etc/resolv.conf"
        sudo cp /etc/resolv.conf /etc/resolv.conf.original
        
        echo -e "\n## Added by setup-googledns.sh on $(date)" | sudo tee --append /etc/resolv.conf
        echo "nameserver 8.8.8.8"   | sudo tee --append /etc/resolv.conf
        echo "nameserver 8.8.4.4"   | sudo tee --append /etc/resolv.conf
    fi
    
    if [ -e /etc/dhcp3/dhclient.conf ]
    then
        echo "Adding to /etc/dhcp3/dhclient.conf"
        sudo cp /etc/dhcp3/dhclient.conf /etc/dhcp3/dhclient.conf.original
        echo -e "\n## Added by setup-googledns.sh on $(date)" | sudo tee --append /etc/dhcp3/dhclient.conf
        echo "prepend domain-name-servers 8.8.8.8, 8.8.4.4;"  | sudo tee --append /etc/dhcp3/dhclient.conf
    fi
    
else
    echo "Google dns could not be reached."
fi
