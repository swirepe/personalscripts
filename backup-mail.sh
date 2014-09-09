#!/usr/bin/env bash
CURRDIR="$(pwd)"

PATH="$PATH:$HOME/pers/scripts:$HOME/pers/scripts/scriptinclude"

source ssh_tmp_agent.sh
source update_machines.sh



if [[ "$1" == "--install" ]]
then
    if [[ "$(crontab -l | grep backup-varmail.sh)" ]]
    then
        echo "backup-varmail.sh already installed."
    else
        echo "Installing."
        crontab -l | { cat; echo -e "\n# Added on $(date) by backup-varmail.sh\n# backup ssh public key files every day at 9am.\n0 9 * * * $HOME/pers/scripts/backup-varmail.sh"; } | crontab -
    fi
	crontab -l | grep backup-varmail.sh
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


MAIL_DIR="$PERS_DIR/machines/mail/$(hostname)"

if [ ! -d $MAIL_DIR ]
then
    echo "$MAIL_DIR does not exist: creating."
    mkdir -p $MAIL_DIR
fi


cd $MAIL_DIR

sudo cp /var/mail .
sudo chown -R $(whoami) .
git add .  
git commit -m "$(hostname) varmail"
git push origin master

cd "$CURRDIR"
