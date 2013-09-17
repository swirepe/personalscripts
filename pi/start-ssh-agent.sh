#!/usr/bin/env bash

echo "Adding ssh-agent to crontab with shared socket"

if [[ "$(crontab -l | grep ssh-agent)" ]]
then
    echo "ssh-agent already in crontab"
else
    echo "Installing."
    crontab -l | { cat; echo -e "\n# Added on $(date) by start-ssh-agent.sh\n# Start ssh agent with a shared socket on boot.\n@reboot /usr/bin/ssh-agent -a $HOME/.ssh-socket"; } | crontab -
fi
crontab -l | grep ssh-agent
echo "Done."
exit 0
