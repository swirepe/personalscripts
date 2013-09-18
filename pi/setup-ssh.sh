#!/usr/bin/env bash
echo "This can all be handled by raspi-config."
echo "Run that instead."

echo "Changing user pi's password"
sudo passwd pi


echo "Changing ssh port from 22 to 212"
if grep "^Port 22" /etc/ssh/sshd_config
then
    sudo sed -i 's/^Port 22/Port 212/' /etc/ssh/sshd_config
else
    echo "Port 212" | sudo tee /etc/ssh/sshd_config
fi



echo "Allowing TCP Port Forwarding"
if grep "^AllowTcpForwarding no" /etc/ssh/sshd_config 
then
    sudo sed -i 's/^AllowTcpForwarding no/AllowTcpForwarding yes/' /etc/ssh/sshd_config
else
    echo "AllowTcpForwarding yes" | sudo tee /etc/ssh/sshd_config
fi


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


