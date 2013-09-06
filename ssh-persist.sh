#!/usr/bin/env bash
# http://interrobeng.com/2013/08/25/speed-up-git-5x-to-50x/
echo "Adding persistence options to ~/.ssh/config"

cp ~/.ssh/config ~/.ssh/config-original

PREAMBLE="\n## added on $(date) by ssh-persist.sh\n"

if grep 'ControlMaster' ~/.ssh/config
then
	echo "'ControlMaster' found."
else
	echo -e "${PREAMBLE}ControlMaster auto" >> ~/.ssh/config
	echo -e "ControlMaster auto enables the sharing of multiple SSH sessions over a single network connection, and auto-creating a master connection if it does not already exist.\n"
fi

if grep 'ControlPath' ~/.ssh/config
then
	echo "'ControlPath' found."
else
	echo -e "${PREAMBLE}ControlPath /tmp/%r@%h:%p" >> ~/.ssh/config
	echo -e "ControlPath /tmp/%r@%h:%p specifies the path to the control socket used for connection sharing. %r will be substituted by the remote login username, %h by the target host name and %p by the port.\n"
fi

if grep 'ControlPersist' ~/.ssh/config
then
	echo "'ControlPersist' found."
else
	echo -e "${PREAMBLE}ControlPersist yes" >> ~/.ssh/config
	echo -e "ControlPersist yes keeps the master connection open in the background indefinitely."
fi


