#!/usr/bin/env bash
CURRDIR="$(pwd)"

PATH="$PATH:$HOME/pers/scripts:$HOME/pers/scripts/scriptinclude"


source ssh_tmp_agent.sh
source update_machines.sh



if [[ "$1" == "--install" ]]
then
    if [[ "$(crontab -l | grep backup-hosts.sh)" ]]
    then
        echo "backup-cron.sh already installed."
    else
        echo "Installing."
        crontab -l | { cat; echo -e "\n# Added on $(date) by backup-hosts.sh\n# backup hosts file every day at 1am.\n0 1 * * * $HOME/pers/scripts/backup-hosts.sh"; } | crontab -
    fi
	crontab -l | grep backup-hosts.sh
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
	git pull origin master
else
	echo "No machines repository found.  Cloning."
	git clone git@bitbucket.org:swirepe/machines.git $PERS_DIR/machines
fi


HOSTS_DIR="$PERS_DIR/machines/hosts/$(hostname)"

if [ ! -d $HOSTS_DIR ]
then
    echo "$HOSTS_DIR does not exist: creating."
    mkdir -p $HOSTS_DIR
fi




cd $HOSTS_DIR
sudo cp /etc/hosts .
git add .  
git commit -m "$(hostname) hosts"
git push origin master

cd "$CURRDIR"
