#!/usr/bin/env bash
CURRDIR="$(pwd)"
PATH="$PATH:$HOME/pers/scripts:$HOME/pers/scripts/scriptinclude"


source ssh_tmp_agent.sh
source update_machines.sh

if [ ! -d /var/lib/tor ]
then
    exit 0
fi

if [[ "$1" == "--install" ]]
then
    if [[ "$(crontab -l | grep backup-torservices.sh)" ]]
    then
        echo "backup-torservices.sh already installed."
    else
        echo "Installing."
        crontab -l | { cat; echo -e "\n# Added on $(date) by backup-torservices.sh\n# backup tor services every day.\n@daily $HOME/pers/scripts/backup-torservices.sh"; } | crontab -
    fi
	crontab -l | grep backup-torservices.sh
	echo "Done."
	exit 0
fi



TORSERVICE_DIR="$PERS_DIR/machines/torservices/$(hostname)"

if [ ! -d $TORSERVICE_DIR ]
then
    echo "$TORSERVICE_DIR does not exist: creating."
    mkdir -p $TORSERVICE_DIR
fi

cd $TORSERVICE_DIR

sudo cp -r /var/lib/tor .
sudo chown -R $(whoami) .
git add .  
git commit -m "$(hostname) tor services"
git push origin master

cd "$CURRDIR"
