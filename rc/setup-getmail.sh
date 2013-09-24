wget http://pyropus.ca/software/getmail/old-versions/getmail-4.43.0.tar.gz -O ~/getmail.tar.gz
tar xzf ~/getmail.tar.gz
cd ~/getmail*
sudo python setup.py install


mkdir -p /media/mass/mail/cur/
mkdir -p /media/mass/mail/new/
mkdir -p /media/mass/mail/tmp/


mkdir ~/.getmail/
chmod 700 ~/.getmail
openssl des3 -d -in $SCRIPTS_DIR/rc/getmailrc.des3 -out ~/.getmail/getmailrc

sudo touch /var/log/getmail.log
sudo chown swirepe /var/log/getmail.log
chmod 700 /var/log/getmail.log


crontab -l { cat; echo -e "\n#Added on $(date) by setup-getmail.sh\n# get new email every five minutes\n*/5 * * * * getmail --quiet"; } | crontab -

