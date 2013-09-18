#!/usr/bin/env bash

RSA_BIT=8192
DSA_BIT=1024


RSA_PATH="$HOME/pers/keys/HOST-$(hostname)-${RSA_BIT}bit-$(date -I)-rsa-key"
DSA_PATH="$HOME/pers/keys/HOST-$(hostname)-${DSA_BIT}bit-$(date -I)-dsa-key"

echo "Removing old keys."
sudo rm /etc/ssh/ssh_host_rsa_key
sudo rm /etc/ssh/ssh_host_rsa_key.pub

sudo rm /etc/ssh/ssh_host_dsa_key
sudo rm /etc/ssh/ssh_host_dsa_key.pub


echo "Generating RSA key in $RSA_PATH"
ssh-keygen -N '' -t rsa -b $RSA_BIT -f $RSA_PATH

echo "Generating DSA key in $DSA_PATH"
ssh-keygen -N '' -t dsa -b $DSA_BIT -f $DSA_PATH


echo "Setting permissions on RSA keys."
sudo chown root:root "${RSA_PATH}"
sudo chown root:root "${RSA_PATH}.pub"
sudo chmod 644 "${RSA_PATH}"
sudo chmod 644 "${RSA_PATH}.pub"


echo "Setting permissions on DSA keys."
sudo chown root:root "${DSA_PATH}"
sudo chown root:root "${DSA_PATH}.pub"
sudo chmod 644 "${DSA_PATH}"
sudo chmod 644 "${DSA_PATH}.pub"


echo "Symlinking RSA keys to /etc/ssh/ssh_host_rsa_key"
sudo ln -s "${RSA_PATH}"     /etc/ssh/ssh_host_rsa_key
sudo ln -s "${RSA_PATH}.pub" /etc/ssh/ssh_host_rsa_key.pub


echo "Symlinking DSA keys to /etc/ssh/ssh_host_dsa_key"
sudo ln -s "${DSA_PATH}"     /etc/ssh/ssh_host_dsa_key
sudo ln -s "${DSA_PATH}.pub" /etc/ssh/ssh_host_dsa_key.pub



if [ -f /etc/ssh/ssh_host_ecdsa_key ]
then
    echo "ECDSA key found.  Assuming that ssh-keygen can create them."
    ECDSA_PATH="$HOME/pers/keys/HOST-$(hostname)-${ECDSA_BIT}bit-$(date -I)-ecdsa-key"
    ECDSA_BIT=1024
    
    echo "Generating ECDSA key in $ECDSA_PATH"
    ssh-keygen -N '' -t ecdsa -b $ECDSA_BIT -f $ECDSA_PATH

    echo "Setting permissions on ECDSA keys."
    sudo chown root:root "${ECDSA_PATH}"
    sudo chown root:root "${ECDSA_PATH}.pub"
    sudo chmod 644 "${ECDSA_PATH}"
    sudo chmod 644 "${ECDSA_PATH}.pub"
    
    echo "Removing old ecdsa keys."
    sudo rm /etc/ssh/ssh_host_ecdsa_key
    sudo rm /etc/ssh/ssh_host_ecdsa_key.pub
    
    echo "Symlinking ECDSA keys to /etc/ssh/ssh_host_dsa_key"
    sudo ln -s "${ECDSA_PATH}"     /etc/ssh/ssh_host_ecdsa_key
    sudo ln -s "${ECDSA_PATH}.pub" /etc/ssh/ssh_host_ecdsa_key.pub


fi
