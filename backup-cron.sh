#!/usr/bin/env bash
CURRDIR="$(pwd)"
PATH="$PATH:$HOME/pers/scripts"

## note: this will not pick up on crons for deleted users.  for that, you 
## need to poke around in /var/spool/cron


function users {
	if [[ "$(which dscl)" ]]                   ## mac osx
	then
		sudo dscl . list /users 
	elif [[ "$(which getent)" ]]               ## get administrator database
	then
		getent passwd | cut -d: -f1 | sort
	elif [[ -e /etc/passwd ]]                  ## ok, go directly to where the users are
	then
		cat /etc/passwd | cut -d: -f1 | sort
	else
		echo "Error: cannot list users" > /dev/stderr
		exit 1
	fi
}


if [[ "$1" == "--install" ]]
then
    if [[ "$(crontab -l | grep backup-cron.sh)" ]]
    then
        echo "backup-cron.sh already installed."
    else
        echo "Installing."
        crontab -l | { cat; echo -e "\n# Added on $(date) by backup-cron.sh\n# backup crontabs every day.\n@daily $HOME/pers/scripts/backup-cron.sh"; } | crontab -
    fi
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
	git pull --no-edit origin master
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
    echo "$user "
	sudo crontab -u "$user" -l > "$CRON_DIR/$user"
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
