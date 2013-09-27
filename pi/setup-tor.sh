#!/usr/bin/env bash
echo "Installing ntp."
sudo apt-get install -y ntp gpg

echo "Adding Torproject's Wheezy to the apt list."
echo "deb     http://deb.torproject.org/torproject.org wheezy main" | sudo tee --append  /etc/apt/sources.list

echo "Adding in the keys for torproject."
gpg --keyserver keys.gnupg.net --recv 886DDD89
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -

echo "Adding in the keyring."
sudo apt-get install -y deb.torproject.org-keyring

echo "Installiing tor."
sudo apt-get install -y tor


function torrc-append {
	echo "$1" | sudo tee --append /etc/tor/torrc
}





torrc-append "## Added by setup-tor.sh on $(date)"
torrc-append "SocksPort 9050             # what port to open for local application connections (0 to run only as a server)"
torrc-append "SocksBindAddress 127.0.0.1 # accept connections only from localhost"
torrc-append "Log notice file /var/log/tor/notices.log"
torrc-append "RunAsDaemon 1"
torrc-append "ORPort 9080"
torrc-append "DirPort 9030"
torrc-append "ExitPolicy reject *:*"
torrc-append "Nickname rasptor"
torrc-append "RelayBandwidthRate 100 KB  # Throttle traffic to 100KB/s (800Kbps)"
torrc-append "RelayBandwidthBurst 200 KB # But allow bursts up to 200KB/s (1600Kbps)"
torrc-append "#User tor"
torrc-append "#Group tor"
torrc-append "#PidFile /var/run/tor.pid"

echo "Restarting tor."
sudo service tor reload
sudo /etc/init.d/tor restart
