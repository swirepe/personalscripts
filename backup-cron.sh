#!/usr/bin/env bash
CURRDIR="$(pwd)"
PATH="$PATH:$HOME/pers/scripts"

# fail on any errors (same as set -e)
set -o errexit

function error() {
    JOB="$0"              # job name
    LASTLINE="$1"         # line of error occurrence
    LASTERR="$2"          # error code
    echo -e "${COLOR_Red}ERROR in ${JOB} : line ${LASTLINE} with exit code ${LASTERR}: $(sed -n ${LASTLINE}p $THIS_SCRIPT_PATH) ${COLOR_off}"
    exit 1
}
trap 'error ${LINENO} ${$?}' ERR


function users {
	if [[ "$(which dscl)" ]]
	then
		sudo dscl . list /users 
	elif [[ "$(which getent)" ]]
	then
		getent passwd | cut -d: -f1 | sort
	elif [[ -e /etc/passwd ]]
	then
		cat /etc/passwd | cut -d: -f1 | sort
	else
		echo "Error: cannot list users" > /dev/stderr
		exit 1
	fi
}


if [[ "$1" == "--install" ]]
then
	echo "Installing."
	crontab -l | { cat; echo "@daily $HOME/pers/scripts/backup-cron.sh"; } | crontab -
	crontab -l | grep backup-cron.sh
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


CRON_DIR="$PERS_DIR/machines/cron/$(hostname)"

if [ ! -d $CRON_DIR ]
then
    echo "$CRON_DIR does not exist: creating."
    mkdir -p $CRON_DIR
fi

## Loop through users
cd $CRON_DIR
for user in $(users)
do
	sudo crontab -u $user -l > $CRON_DIR/$user 2>/dev/null
done


## run the lscron script, if it exists
if [[ "$(which lscron)" ]]
then
	lscron > $CRON_DIR/CRONTAB.txt
fi

git add .  
git commit -m "$(hostname) cron"
git push origin master

cd "$CURRDIR"
