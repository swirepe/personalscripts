#!/usr/bin/env bash
# http://interrobeng.com/2013/08/25/speed-up-git-5x-to-50x/
echo "Adding persistence options to ~/.ssh/config"

cp ~/.ssh/config ~/.ssh/config-original

echo -e "\n## added on $(date) by ssh-persist.sh\n" >> ~/.ssh/config
echo "Host *" >> ~/.ssh/config
echo -e "    ControlMaster auto" >> ~/.ssh/config
echo -e "ControlMaster auto enables the sharing of multiple SSH sessions over a single network connection, and auto-creating a master connection if it does not already exist.\n"

echo -e "    ControlPath /tmp/%r@%h:%p" >> ~/.ssh/config
echo -e "ControlPath /tmp/ssh-%r@%h:%p specifies the path to the control socket used for connection sharing. %r will be substituted by the remote login username, %h by the target host name and %p by the port.\n"

echo -e "    ControlPersist yes" >> ~/.ssh/config
echo -e "ControlPersist yes keeps the master connection open in the background indefinitely."



