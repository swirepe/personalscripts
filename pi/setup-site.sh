#!/usr/bin/env bash

echo -e "${COLOR_BBlue}Installing lighttpd and php${COLOR_off}"
sagi -y lighttpd php5-cgi php5-common php5-gd

sudo lighty-enable-mod fastcgi
sudo lighty-enable-mod fastcgi-php
sudo service lighttpd force-reload

echo -e "${COLOR_BBlue}Cloning repository${COLOR_off}"
sudo git clone git@bitbucket.org:swirepe/neurokyme-site.git /var/www
sudo rm -rf /var/www/.git

if [[ "$(crontab -l | grep netstat)" ]]
then
    echo "Crontab may already be installed."
else
    echo -e "${COLOR_BBlue}Installing crontab for site stats${COLOR_off}"
    sudo touch /var/log/foreignhosts.log
    sudo chown $(whoami) /var/log/foreignhosts.log
        
    crontab -l { cat; echo -e "\n#Added on $(date) by setup-site.sh\n#Get a record of connected foreign hosts every five minutes\n# for traffic reporting on neurokyme\n*/5 * * * * netstat -t -u --wide | awk '{print \$5}' | cut -d: -f1 | sort | uniq -c | sort -nr > /var/log/foreignhosts.log"; } | crontab -
    crontab -l | grep "netstat"

fi

echo -e "${COLOR_BGreen}Done.${COLOR_off}"
