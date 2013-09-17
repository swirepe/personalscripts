#!/usr/bin/env bash
# crontab -u sshd -e
# find $HOME/pers/machines/keys -name '*.pub' -exec cat '{}' +
# actually, I think we can just run this from user swirepe


if [[ "$1" == "--install" ]]
then
    if [[ "$(crontab -l | grep add-keys-from-machines-repo.sh)" ]]
    then
        echo "add-keys-from-machines-repo.sh already installed."
    else
        echo "Installing."
        crontab -l | { cat; echo -e "\n# Added on $(date) by add-keys-from-machines-repo.sh\n# update the authorized hosts file every 6 hours\n0 0,6,12,18 * * * $HOME/pers/scripts/pi/add-keys-from-machines-repo.sh"; } | crontab -
    fi
	crontab -l | grep add-keys-from-machines-repo.sh
	echo "Done."
	exit 0
fi



cd $HOME/pers/machines
git pull


#SSHD_HOME=$(cat /etc/passwd | grep sshd | cut -d : -f 6)
SSHD_HOME="$HOME/.ssh"

echo -e "# Created by add-keys-from-machines.sh on $(date -I)\n# -------------------\n" > $SSHD_HOME/authorized_keys

for host in $(find $HOME/pers/machines/pubkeys -name '*.pub' ) 
do
    cat $host >> $SSHD_HOME/authorized_keys
done


echo -e "\n# -------------------" >> $SSHD_HOME/authorized_keys


chmod 600 $SSHD_HOME/authorized_keys

# in /etc/passwd 
# sshd:x:115:65534::/var/run/sshd:/usr/sbin/nologin
