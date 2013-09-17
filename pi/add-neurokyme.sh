#!/usr/bin/env bash

if [[ ! -z "$(grep neurokyme ~/.ssh/config)" ]]
then
    echo "Neurokyme already added to ~/.ssh/config"
    grep neurokyme ~/.ssh/config
    exit 1
fi


echo -e  "\n## ---------------------------------------" >> $HOME/.ssh/config
echo     "## added on $(date) by add-neurokyme.sh   "   >> $HOME/.ssh/config
echo     "Host neurokyme                            "   >> $HOME/.ssh/config
echo     "    User swirepe                          "   >> $HOME/.ssh/config
echo     "    HostName neuroky.me                   "   >> $HOME/.ssh/config
echo     "    Port 212                              "   >> $HOME/.ssh/config
echo     "                                          "   >> $HOME/.ssh/config
echo     "## ---------------------------------------"   >> $HOME/.ssh/config
