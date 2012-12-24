# The wifi at home uses wep 64 bit.
# the ubuntu gui doesn't support that

sudo /etc/init.d/network-manager stop
# sudo iwlist wlan0 scan
sudo iwconfig wlan0 essid V8XB1
sudo iwconfig wlan0 key 12E5D82969 open
sudo dhclient wlan0

