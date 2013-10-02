#!/usr/bin/env bash

if [ ! -d $HOME/pers/keys ]
then
    echo "$HOME/pers/keys not found."
    exit 1
fi

echo "Starting ssh agent."
eval `ssh-agent -s` 

echo "Adding in currently-known keys."
for pubkey in $(ls ~/pers/keys/*.pub)
do 
    # strip off the last 4 characters so we get a private key
    echo $pubkey | sed 's/....$//' | xargs ssh-add
done


echo "Generating new host keys."
chmod +x $HOME/pers/scripts/pi/new-ssh-host-keys.sh
$HOME/pers/scripts/pi/new-ssh-host-keys.sh


echo "Generating new client keys."
ssh-keygen -t rsa -N "" -b 4096 -f "$HOME/pers/keys/$(whoami)-$(hostname)-4096bit-$(date -I)-key"
chmod -R go-rw $HOME/pers/keys/


echo "Adding keys from machines repository."
chmod +x $HOME/pers/scripts/pi/add-keys-from-machines-repo.sh
$HOME/pers/scripts/pi/add-keys-from-machines-repo.sh

echo "Installing cronjob to add keys from repository."
$HOME/pers/scripts/pi/add-keys-from-machines-repo.sh --install


echo "Backing up public keys."
chmod +x $HOME/pers/scripts/pi/backup-pubkeys.sh
$HOME/pers/scripts/pi/backup-pubkeys.sh

echo "Installing cronjob to back up public keys."
$HOME/pers/scripts/pi/backup-pubkeys.sh --install


echo "Symlinking current keys."
chmod +x $HOME/pers/scripts/pi/symlink-keys.sh
$HOME/pers/scripts/pi/symlink-keys.sh


echo "Installing sshd_config"
sudo mv /etc/ssh/sshd_config /etc/ssh/sshd_config.original
sudo cp $HOME/pers/scripts/pi/sshd_config /etc/ssh/sshd_config


echo "Creating ssh group"
sudo groupadd -f ssh

echo "Adding swirepe to ssh group"
sudo usermod -a -G ssh swirepe


echo "Creating kingslayer user for sftp"
chmod +x $HOME/pers/scripts/pi/add-sftp-user.sh
sudo $HOME/pers/scripts/pi/add-sftp-user.sh 'kingslayer' 'writeharddiefree'


echo "Telling ssh agent to start on boot"
chmod +x $HOME/pers/scripts/pi/start-ssh-agent.sh
$HOME/pers/scripts/pi/start-ssh-agent.sh
