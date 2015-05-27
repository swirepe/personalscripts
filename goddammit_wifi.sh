#!/usr/bin/env bash
echo "Seeing if we can already access the internet."
ping -c 1 google.com && exit 

echo "Removing and reinstalling the wifi driver rtl8192se"
# you get that from 
# lshw -class network
# specifically, from
# lshw -class network | grep --only-matching --extended-regexp 'driver\=\w*' | sed s/driver=//
sudo rmmod rtl8192se
sudo modprobe rtl8192se
echo "Pinging google."
ping google.com -c 1 && exit
echo "Continuing."

echo "Bringing down the wireless interface."
sudo ifconfig wlan0 down
echo "Sleeping."
sleep 5
echo "Bringing up the wireless interface."
sudo ifconfig wlan0 up
echo "Trying to reach google.com"
ping -c 1 google.com && exit
echo "No luck,  Trying something else."

echo "Powering down wifi card."
sudo iwconfig wlan0 txpower off
echo "Sleeping."
sleep 15
echo "Powering up wifi card."
sudo iwconfig wlan0 txpower auto
echo "Is google a thing?"
ping -c 1 google.com && exit
echo "No? Goddammit."

echo "Letting rfkill do its thing."
sudo rfkill block wifi
echo "Sleeping."
sleep 10
sudo rfkill unblock wifi
echo "Is google there yet?"
ping -c 1 google.com && exit
echo "Fuck."

echo "Restarting network manager"
sudo service network-manager restart
echo "Maybe google is back..."
ping -c 1 google.com && exit

toilet --gay GODDAMMIT.
