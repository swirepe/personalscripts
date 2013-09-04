#!/usr/bin/env bash
echo "This can all be handled by raspi-config."
echo "Run that instead."

echo "Changing user pi's password"
sudo passwd pi


echo "Changing ssh port from 22 to 212"
sudo sed -i 's/^Port 22/Port 212/' /etc/ssh/sshd_config


if [[ "$(hostname)" == "raspberry" ]]
then
    if [[ -z "$1" ]]
    then
        HOSTNAME="betta"
    else
        HOSTNAME="$1"
    fi
    
    
    echo -n "Setting hostname: "
    echo $HOSTNAME | sudo tee /etc/hostname
    
    echo "Restarting hostname service."
    sudo service hostname restart

fi


