#!/usr/bin/env bash
CURRDIR="$(pwd)"

PATH="$PATH:$HOME/pers/scripts:$HOME/pers/scripts/scriptinclude"

source ssh_tmp_agent.sh
source update_machines.sh



if [[ "$1" == "--install" ]]
then
    if [[ "$(crontab -l | grep backup-syslog.sh)" ]]
    then
        echo "backup-syslog.sh already installed."
    else
        echo "Installing."
        crontab -l | { cat; echo -e "\n# Added on $(date) by backup-syslog.sh\n# backup ssh public key files every day at 9am.\n0 9 * * * $HOME/pers/scripts/backup-syslog.sh"; } | crontab -
    fi
	crontab -l | grep backup-syslog.sh
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


SYSLOG_DIR="$PERS_DIR/machines/syslog/$(hostname)"

if [ ! -d $SYSLOG_DIR ]
then
    echo "$SYSLOG_DIR does not exist: creating."
    mkdir -p $SYSLOG_DIR
fi


cd $SYSLOG_DIR

sudo mv /var/log/syslog .
sudo touch /var/log/syslog
sudo chown -R $(whoami) .
git add .  
git commit -m "$(hostname) syslogs"
git push origin master

cd "$CURRDIR"
