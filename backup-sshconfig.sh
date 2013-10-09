#!/usr/bin/env bash
CURRDIR="$(pwd)"

PATH="$PATH:$HOME/pers/scripts:$HOME/pers/scripts/scriptinclude"


source ssh_tmp_agent.sh
source update_machines.sh



if [[ "$1" == "--install" ]]
then
    if [[ "$(crontab -l | grep backup-sshconfig.sh)" ]]
    then
        echo "backup-sshconfig.sh already installed."
    else
        echo "Installing."
        crontab -l | { cat; echo -e "\n# Added on $(date) by backup-sshconfig.sh\n# backup ssh public key files every day at 10am.\n0 10 * * * $HOME/pers/scripts/backup-sshconfig.sh"; } | crontab -
    fi
	crontab -l | grep backup-sshconfig.sh
	echo "Done."
	exit 0
fi


SSHCONFIG_DIR="$PERS_DIR/machines/sshconfig/$(hostname)"

if [ ! -d $SSHCONFIG_DIR ]
then
    echo "$SSHCONFIG_DIR does not exist: creating."
    mkdir -p $SSHCONFIG_DIR
fi




cd $SSHCONFIG_DIR
sudo cp ~/.ssh/config sshconfig.local
sudo cp /etc/ssh/ssh_config sshconfig.global
git add .  
git commit -m "$(hostname) sshconfig"
git push origin master

cd "$CURRDIR"
