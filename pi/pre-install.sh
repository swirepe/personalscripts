#!/usr/bin/env bash


COLOR_off='\033[0m'
COLOR_Red='\033[0;31m'
COLOR_BGreen='\033[1;32m'
COLOR_BYellow='\033[1;33m'
COLOR_Blue='\033[0;34m'
COLOR_BIBlue='\033[1;94m' 

function replace_profile {
    sudo mv /etc/profile-original /etc/profile 
    sudo rm -f /pi-install-profile-tainted
}


function taint_profile {
    if [ -e /pi-install-profile-tainted ]
    then
        echo "/pi-install-profile-tainted found.  Not re-tainting profile."
        return 0
    fi
    
    PARENT_SCRIPT="$1"
    sudo cp /etc/profile /etc/profile-original
    echo '' | sudo tee /etc/profile
    
    NEW_PARENT_SCRIPT="/usr/local/bin/$(basename $PARENT_SCRIPT)"
    echo -e "${COLOR_Blue}Moving $PARENT_SCRIPT to $NEW_PARENT_SCRIPT"
    sudo cp "$PARENT_SCRIPT $NEW_PARENT_SCRIPT"
    sudo chmod a+rwx $NEW_PARENT_SCRIPT

                                                                                  
    echo '  if [ "$PS1" ]; then                                                       '  | sudo tee --append /etc/profile
    echo '    if [ "$BASH" ]; then                                                    '  | sudo tee --append /etc/profile
    echo "      PS1='\u@\h:\w\$ '                                                     "  | sudo tee --append /etc/profile
    echo '                                                                            '  | sudo tee --append /etc/profile
    echo '      SETUP_LOG="$HOME/new-machine-setup.log"                               '  | sudo tee --append /etc/profile
    echo '      echo "***********************************" | tee --append $SETUP_LOG  '  | sudo tee --append /etc/profile
    echo '      echo "      RESTARTING SETUP SCRIPT      " | tee --append $SETUP_LOG  '  | sudo tee --append /etc/profile
    echo '      echo "***********************************" | tee --append $SETUP_LOG  '  | sudo tee --append /etc/profile
    echo "      $NEW_PARENT_SCRIPT | tee --append \$SETUP_LOG                         "  | sudo tee --append /etc/profile
    echo '                                                                            '  | sudo tee --append /etc/profile
    echo '      if [ -f /etc/bash.bashrc ]; then                                      '  | sudo tee --append /etc/profile
    echo '  	. /etc/bash.bashrc                                                    '  | sudo tee --append /etc/profile
    echo '      fi                                                                    '  | sudo tee --append /etc/profile
    echo '    fi                                                                      '  | sudo tee --append /etc/profile
    echo '  fi                                                                        '  | sudo tee --append /etc/profile
    echo '                                                                            '  | sudo tee --append /etc/profile
    echo '  umask 022                                                                 '  | sudo tee --append /etc/profile
    
    sudo touch /pi-install-profile-tainted
}




# install the stuff we need, set the parent script to run on reboot, then reboot


PARENT_SCRIPT="$1"
echo -e "${COLOR_Blue}Tainting /etc/profile${COLOR_off}"
taint_profile $PARENT_SCRIPT
echo -e "${COLOR_BIBlue}Tainted /etc/profile.  Parent script will continue on reboot.${COLOR_off}"




echo -e "${COLOR_Blue}Fetching raspberry pi scripts.${COLOR_off}"
mkdir -p $HOME/pi
cd $HOME/pi

    
[ -e setup-rootfs.sh  ] || wget https://raw.github.com/swirepe/personalscripts/master/pi/setup-rootfs.sh
[ -e setup-tor.sh     ] || wget https://raw.github.com/swirepe/personalscripts/master/pi/setup-tor.sh
[ -e setup-ssh.sh     ] || wget https://raw.github.com/swirepe/personalscripts/master/pi/setup-ssh.sh
[ -e setup-motd.sh    ] || wget https://raw.github.com/swirepe/personalscripts/master/pi/setup-motd.sh

chmod +x setup-rootfs.sh
chmod +x setup-tor.sh
chmod +x setup-ssh.sh
chmod +x setup-motd.sh    



echo -e "${COLOR_Blue}Expanding the rootfs.${COLOR_off}"
./setup-rootfs.sh
echo -e "${COLOR_BIBlue}Rootfs will expand on reboot.${COLOR_off}"


echo -e "${COLOR_Blue}Setting up tor.${COLOR_off}"
./setup-tor.sh
echo -e "${COLOR_BIBlue}Setting up tor complete.${COLOR_off}"


echo -e "${COLOR_Blue}Setting up ssh.${COLOR_off}"
./setup-ssh.sh
echo -e "${COLOR_BIBlue}Setting up ssh complete.${COLOR_off}"


echo -e "${COLOR_Blue}Setting up motd.${COLOR_off}"
./setup-motd.sh
echo -e "${COLOR_BIBlue}Setting up motd complete.${COLOR_off}"



echo -e "${COLOR_Blue}Putting /etc/profile back${COLOR_off}"
replace_profile
echo -e "${COLOR_BIBlue}Done putting /etc/profile back${COLOR_off}"


echo -e "${COLOR_BGreen}Raspberry pi preinstall has been done.${COLOR_off}"
exit 0
