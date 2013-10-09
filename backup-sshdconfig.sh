#!/usr/bin/env bash
CURRDIR="$(pwd)"

PATH="$PATH:$HOME/pers/scripts:$HOME/pers/scripts/scriptinclude"


source ssh_tmp_agent.sh
source update_machines.sh


if [[ "$1" == "--install" ]]
then
    if [[ "$(crontab -l | grep backup-sshdconfig.sh)" ]]
    then
        echo "backup-sshdconfig.sh already installed."
    else
        echo "Installing."
        crontab -l | { cat; echo -e "\n# Added on $(date) by backup-sshdconfig.sh\n# backup sshd config files every day at 11am.\n0 11 * * * $HOME/pers/scripts/backup-sshdconfig.sh"; } | crontab -
    fi
	crontab -l | grep backup-sshdconfig.sh
	echo "Done."
	exit 0
fi





SSHDCONFIG_DIR="$PERS_DIR/machines/sshdconfig/$(hostname)"

if [ ! -d $SSHDCONFIG_DIR ]
then
    echo "$SSHDCONFIG_DIR does not exist: creating."
    mkdir -p $SSHDCONFIG_DIR
fi




cd $SSHDCONFIG_DIR
sudo cp /etc/ssh/sshd_config sshd_config
git add .  
git commit -m "$(hostname) SSHDconfig"
git push origin master

cd "$CURRDIR"
