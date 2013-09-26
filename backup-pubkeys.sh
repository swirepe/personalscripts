#!/usr/bin/env bash
CURRDIR="$(pwd)"




if [[ "$1" == "--install" ]]
then
    if [[ "$(crontab -l | grep backup-pubkeys.sh)" ]]
    then
        echo "backup-pubkeys.sh already installed."
    else
        echo "Installing."
        crontab -l | { cat; echo -e "\n# Added on $(date) by backup-pubkeys.sh\n# backup ssh public key files every day at 9am.\n0 9 * * * $HOME/pers/scripts/backup-pubkeys.sh"; } | crontab -
    fi
	crontab -l | grep backup-pubkeys.sh
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


KEYS_DIR="$PERS_DIR/machines/pubkeys/$(hostname)"

if [ ! -d $KEYS_DIR ]
then
    echo "$KEYS_DIR does not exist: creating."
    mkdir -p $KEYS_DIR
fi




cd $KEYS_DIR
sudo cp ~/.ssh/*.pub .
sudo cp ~/pers/keys/*.pub .
git add .  
git commit -m "$(hostname) public_keys"
git push origin master

cd "$CURRDIR"
