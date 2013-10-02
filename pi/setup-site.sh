#!/usr/bin/env bash

echo -e "${COLOR_BBlue}Installing lighttpd and php${COLOR_off}"
sagi -y lighttpd php5-cgi php5-common php5-gd php5-cli xsltproc

sudo lighty-enable-mod fastcgi
sudo lighty-enable-mod fastcgi-php
sudo service lighttpd force-reload

echo -e "${COLOR_BBlue}Cloning repository${COLOR_off}"
git archive --format=tar --remote=git@bitbucket.org:swirepe/neurokyme-site.git master | sudo tar -C /var/www -xf  -

echo -e "${COLOR_BBlue}Moving utilities${COLOR_off}"

# foreign hosts
sudo chmod a+x /var/www/util/services/foreign_hosts
sudo cp /var/www/util/services/foreign_hosts /etc/init.d/foreign_hosts
sudo touch /var/log/foreignhosts.log
sudo chown $(whoami) /var/log/foreignhosts.log
sudo chmod a+rw /var/log/foreignhosts.log
sudo /etc/init.d/foreign_hosts start

# netspeed listen
sudo chmod a+x /var/www/util/services/netspeed_listen
sudo cp /var/www/util/services/netspeed_listen /etc/init.d/netspeed_listen
sudo touch /var/log/netspeed.log
sudo chown $(whoami) /var/log/netspeed.log
sudo chmod a+rw  /var/log/netspeed.log
sudo /etc/init.d/netspeed_listen start

# speed report
sudo chmod a+x /var/www/util/services/speed_report
sudo cp /var/www/util/services/speed_report /etc/init.d/speed_report
sudo /etc/init.d/speed_report start

# nmap report
sudo chmod a+x /var/www/util/services/nmap_report
sudo cp /var/www/util/services/nmap_report /etc/init.d/nmap_report
sudo /etc/init.d/nmap_report start

# torrent log
sudo chmod a+x /var/www/util/services/torrent_log
sudo mv /var/www/util/services/torrent_log /etc/init.d/torrent_log
sudo touch /var/log/torrents.log
sudo touch /var/log/torrents_info.log
sudo touch /var/log/torrents_stats.log
sudo chmod a+rw /var/log/torrents.log
sudo chmod a+rw /var/log/torrents_info.log
sudo chmod a+rw /var/log/torrents_stats.log
sudo chown $(whoami) /var/log/torrents.log
sudo chown $(whoami) /var/log/torrents_info.log
sudo chown $(whoami) /var/log/torrents_stats.log
sudo /etc/init.d/torrent_log start

echo -e "${COLOR_BBlue}Putting the config files in place${COLOR_off}"
sudo mv /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf.bak
sudo mv /var/www/config/lighttpd.conf /etc/lighttpd/lighttpd.conf

sudo mv /etc/php5/cgi/php.ini /etc/php5/cgi/php.ini.bak
sudo mv /var/www/config/php.ini /etc/php5/cgi/php.ini


echo -e "${COLOR_BBlue}Setting up https${COLOR_off}"
sudo mkdir -p /etc/lighttpd/ssl
sudo mv /var/www/config/neurokyme.pem /etc/lighttpd/ssl/neurokyme.pem
sudo chown root:root /etc/lighttpd/ssl/neurokyme.pem
sudo chmod 400 /etc/lighttpd/ssl/neurokyme.pem


echo -e "${COLOR_BBlue}Setting up logging${COLOR_off}"
sudo mkdir -p /var/log/lighttpd/main
sudo mkdir -p /var/log/lighttpd/dragonet
sudo chown -R www-data:www-data /var/log/lighttpd



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

/etc/init.d/lighttpd force-reload

echo -e "${COLOR_BGreen}Done.${COLOR_off}"



