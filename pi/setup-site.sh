#!/usr/bin/env bash

function add_service {
    SERVICE="$1"
    echo -e "${COLOR_Blue}Adding service ${SERVICE}${COLOR_off}."
    sudo chmod a+x $SERVICE
    
    SERVICE_BASE=$(basename $SERVICE)
    if [ -e /etc/init.d/$SERVICE_BASE ]
    then
        echo -e "${COLOR_Blue}/etc/init.d/$SERVICE_BASE found.  Stopping ${SERVICE_BASE}${COLOR_off}."
        sudo /etc/init.d/$SERVICE_BASE stop
    fi
    sudo cp $SERVICE /etc/init.d/
    echo -e "${COLOR_Blue}Starting service ${SERVICE_BASE}${COLOR_off}."
    sudo /etc/init.d/$SERVICE_BASE start
}

function add_log {
    LOGNAME="$1"
    echo -e "${COLOR_Blue}Adding log ${LOGNAME}${COLOR_off}."
    LOGDIR=$(dirname $LOGNAME)
    echo -e "${COLOR_Blue}Making log directory ${LOGDIR}${COLOR_off}."
    sudo mkdir -p $LOGDIR
    
    sudo touch $LOGNAME
    sudo chown $(whoami) $LOGNAME
    sudo chmod a+rw $LOGNAME
}


echo -e "${COLOR_BBlue}Installing lighttpd and php${COLOR_off}"
sagi -y lighttpd php5-cgi php5-common php5-gd php5-cli php5-pgsql xsltproc python-psycopg2 postgresql libpq-dev

sudo lighty-enable-mod fastcgi
sudo lighty-enable-mod fastcgi-php
sudo service lighttpd force-reload

echo -e "${COLOR_BBlue}Cloning repository${COLOR_off}"
git archive --format=tar --remote=git@bitbucket.org:swirepe/neurokyme-site.git master | sudo tar -C /var/www -xf  -

echo -e "${COLOR_BBlue}Moving utilities${COLOR_off}"


# foreign hosts
add_log /var/log/foreignhosts.log
add_service /var/www/util/services/foreign_hosts

# foreign hosts for db
add_service /var/www/util/services/foreign_hosts_db
sudo cp /var/www/util/sql/hosts.py /usr/local/bin/foreign_hosts_db
sudo chmod a+x /usr/local/bin/foreign_hosts_db


# netspeed listen
add_log /var/log/netspeed.log
add_service /var/www/util/services/netspeed_listen


# speed report
add_service /var/www/util/services/speed_report


# nmap report
add_log /var/log/nmap_report.html
add_log /var/log/nmap_report.xml
add_service /var/www/util/services/nmap_report


# torrent log
add_log /var/log/torrents.log
add_log /var/log/torrents_info.log
add_log /var/log/torrents_stats.log
add_log /var/log/torrents_individual.log
add_service /var/www/util/services/torrent_log


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


echo -e "${COLOR_BBlue}Setting up postgresql${COLOR_off}"
sudo mkdir /media/mass/postgres
sudo chown -R postgres /media/mass/postgres
sudo -u postgres initdb --pgdata=/media/mass/postgres
sudo mkdir /media/mass/postgres_logs
sudo chown -R postgres /media/mass/postgres_logs
sudo sed -i "s,^data_directory.*,data_directory = '/media/mass/postgres'," /etc/postgresql/*/main/postgresql.conf
sudo -u postgres psql --dbname hosts -f /var/www/util/sql/hosts.sql

sudo /etc/init.d/postgres* restart

# set up jenny's upload directory
sudo mkdir -p /media/mass/jenny/downloads
sudo chmod -R a+rw /media/mass/jenny/downloads
sudo ln -s /media/mass/jenny/downloads /var/www/jenny/downloads
sudo cp /var/www/config/jenny-upload-HEADER.txt /media/mass/jenny/downloads/HEADER.txt


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



