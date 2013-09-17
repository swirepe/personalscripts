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


echo "Symlinking RSA keys to /etc/ssh/ssh_host_rsa_key"
sudo ln -s "${RSA_PATH}"     /etc/ssh/ssh_host_rsa_key
sudo ln -s "${RSA_PATH}.pub" /etc/ssh/ssh_host_rsa_key.pub


echo "Symlinking DSA keys to /etc/ssh/ssh_host_dsa_key"
sudo ln -s "${DSA_PATH}"     /etc/ssh/ssh_host_dsa_key
sudo ln -s "${DSA_PATH}.pub" /etc/ssh/ssh_host_dsa_key.pub


