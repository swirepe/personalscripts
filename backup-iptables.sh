#!/usr/bin/env bash
CURRDIR="$(pwd)"
PATH="$PATH:$HOME/pers/scripts:$HOME/pers/scripts/scriptinclude"


source ssh_tmp_agent.sh
source update_machines.sh



if [[ "$1" == "--install" ]]
then
    if [[ "$(crontab -l | grep backup-iptables.sh)" ]]
    then
        echo "backup-iptables.sh already installed."
    else
        echo "Installing."
        crontab -l | { cat; echo -e "\n# Added on $(date) by backup-iptables.sh\n# backup iptables rules every day.\n@daily $HOME/pers/scripts/backup-iptables.sh"; } | crontab -
    fi
	crontab -l | grep backup-iptables.sh
	echo "Done."
	exit 0
fi



IPTABLES_DIR="$PERS_DIR/machines/iptables/$(hostname)"

if [ ! -d $IPTABLES_DIR ]
then
    echo "$IPTABLES_DIR does not exist: creating."
    mkdir -p $IPTABLES_DIR
fi

sudo iptables-save > "$IPTABLES_DIR/iptables.rules"

git add .  
git commit -m "$(hostname) iptables"
git push origin master

cd "$CURRDIR"
