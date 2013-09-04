#!/usr/bin/env bash
echo "Installing ntp."
sagi -y ntp gpg

echo "Adding Torproject's Wheezy to the apt list."
echo "deb     http://deb.torproject.org/torproject.org wheezy main" | sudo tee --append  /etc/apt/sources.list

echo "Adding in the keys for torproject."
gpg --keyserver keys.gnupg.net --recv 886DDD89
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -

echo "Adding in the keyring."
sagi -y deb.torproject.org-keyring

echo "Installiing tor."
sagi -y tor


function torrc-append {
	echo "$1" | sudo tee --append /etc/tor/torrc
}


torrc-append "## Added by setup-tor.sh on $(date)"
torrc-append "SocksPort 0"
torrc-append "Log notice file /var/log/tor/notices.log"
torrc-append "RunAsDaemon 1"
torrc-append "ORPort 80"
torrc-append "DirPort 9030"
torrc-append "ExitPolicy reject *:*"
torrc-append "Nickname rasptor"
torrc-append "RelayBandwidthRate 100 KB  # Throttle traffic to 100KB/s (800Kbps)"
torrc-append "RelayBandwidthBurst 200 KB # But allow bursts up to 200KB/s (1600Kbps)"

echo "Restarting."
sudo service tor reload
sudo /etc/init.d/tor restart
