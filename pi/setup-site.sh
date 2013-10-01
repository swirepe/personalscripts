#!/usr/bin/env bash

echo -e "${COLOR_BBlue}Installing lighttpd and php${COLOR_off}"
sagi -y lighttpd php5-cgi php5-common php5-gd php5-cli

sudo lighty-enable-mod fastcgi
sudo lighty-enable-mod fastcgi-php
sudo service lighttpd force-reload

echo -e "${COLOR_BBlue}Cloning repository${COLOR_off}"
git archive --format=tar --remote=git@bitbucket.org:swirepe/neurokyme-site.git master | sudo tar -C /var/www -xf  -

echo -e "${COLOR_BBlue}Moving utilities${COLOR_off}"
sudo chmod a+x /var/www/util/neurokyme_foreignhosts.sh
sudo mv /var/www/util/neurokyme_foreignhosts.sh /etc/init.d/foreign_hosts

sudo chmod a+x /var/www/util/netspeed_listen
sudo mv /var/www/util/netspeed_listen /etc/init.d/netspeed_listen

sudo chmod a+x /var/www/util/speed_report
sudo mv /var/www/util/speed_report /etc/init.d/speed_report


echo -e "${COLOR_BBlue}Putting the config file in place${COLOR_off}"
sudo mv /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf.bak
sudo mv /var/www/config/lighttpd.conf /etc/lighttpd/lighttpd.conf


echo -e "${COLOR_BBlue}Setting up https${COLOR_off}"
sudo mkdir -p /etc/lighttpd/ssl
sudo mv /var/www/config/neurokyme.pem /etc/lighttpd/ssl/neurokyme.pem
sudo chown root:root /etc/lighttpd/ssl/neurokyme.pem
sudo chmod 400 /etc/lighttpd/ssl/neurokyme.pem


echo -e "${COLOR_BBlue}Setting up logging${COLOR_off}"
mkdir -p /var/log/lighttpd/main
mkdir -p /var/log/lighttpd/dragonet
sudo chown -R www-data:www-data /var/log/lightppd


if [[ "$(crontab -l | grep neurokyme_foreignhosts.sh)" ]]
then
    echo "Crontab may already be installed."
else
    echo -e "${COLOR_BBlue}Installing crontab for foreign hosts${COLOR_off}"
    sudo touch /var/log/foreignhosts.log
    sudo touch /var/log/foreignhosts.tmp
    sudo chown $(whoami) /var/log/foreignhosts.log
    sudo chown $(whoami) /var/log/foreignhosts.tmp    
    
    crontab -l | { cat; echo -e "\n#Added on $(date) by setup-site.sh\n#Get a record of connected foreign hosts every five minutes\n# for traffic reporting on neurokyme\n*/5 * * * * neurokyme_foreignhosts.sh"; } | crontab -
    crontab -l | grep "neurokyme_foreignhosts.sh"

fi


if [[ "$(crontab -l | grep monitor.php)" ]]
then
    echo "Crontab may already be installed."
else
    echo -e "${COLOR_BBlue}Installing crontab for temperature monitor${COLOR_off}"
    sudo touch /var/log/foreignhosts.log
    sudo touch /var/log/foreignhosts.tmp
    sudo chown $(whoami) /var/log/foreignhosts.log
    sudo chown $(whoami) /var/log/foreignhosts.tmp    
    
    crontab -l | { cat; echo -e "\n#Added on $(date) by setup-site.sh\n#Get the system temperature every 15 minutes\n# dragonet.neuroky.me/pitemp\n*/15 *  * * *   sudo  /var/www/dragonet/pitemp/monitor.php"; } | crontab -
    crontab -l | grep "monitor.php"

fi



echo -e "${COLOR_BGreen}Done.${COLOR_off}"



