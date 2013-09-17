#!/usr/bin/env bash

# run as root
if [[ $EUID -ne 0 ]]
then
    echo "Please run as root." > /dev/stderr
    exit 1
fi

SFTP_USER="$1"
SFTP_PASS="$2"

if [[ -z "$SFTP_USER" ]] || [[ -z "$SFTP_PASS" ]]
then
    echo "Usage: add-sftp-user.sh USER PASS" > /dev/stderr
    exit 2
fi




echo "Creating group sftpusers" > /dev/stderr
groupadd -f sftpusers

echo "Creating user $USER" > /dev/stderr
useradd -g sftpusers -d $CHROOT_DIR/home/$SFTP_USER -s /sbin/nologin $SFTP_USER
echo "$SFTP_USER:$SFTP_PASS" | sudo chpasswd



CHROOT_DIR_ORIGINAL="$(cat /etc/ssh/sshd_config | grep ChrootDirectory | sed 's/^\s*//' | sed 's/\s\s*/ /' | cut -f2 -d' ')"



for user in $(cat /etc/passwd | cut -f 1 -d:)
do
    g="$(groups $user)"
    if [[ "$g" == *"sftpusers"* ]]
    then
        CHROOT_DIR="$CHROOT_DIR_ORIGINAL"
        CHROOT_DIR=${CHROOT_DIR//\%u/$user}

        mkdir -p $CHROOT_DIR/home/$user
        
        chown -R root:root $CHROOT_DIR
        chmod -R go-w $CHROOT_DIR
        
        
        chown -R $user:sftpusers $CHROOT_DIR/home
        chown -R $user:sftpusers $CHROOT_DIR/home/$user


        
    fi
    
done
