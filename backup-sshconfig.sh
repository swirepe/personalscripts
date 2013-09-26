#!/usr/bin/env bash
CURRDIR="$(pwd)"




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


if [[ -z "$PERS_DIR" ]]
then
    PERS_DIR="$HOME/pers"
fi


if [[ -d $PERS_DIR/machines ]]
then
	echo "Updating machines repository."
	cd $PERS_DIR/machines
	git pull --no-edit origin master
else
	echo "No machines repository found.  Cloning."
	git clone git@bitbucket.org:swirepe/machines.git $PERS_DIR/machines
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
