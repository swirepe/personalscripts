# The wifi at home uses wep 64 bit.
# the ubuntu gui doesn't support that
# http://superuser.com/questions/120402/wep-authentication-suddenly-failing-in-ubuntu

echo -e "${COLOR_White}[home-wifi] Stopping the network manager.${COLOR_off}"
sudo /etc/init.d/network-manager stop
# sudo iwlist wlan0 scan  ## this command doesn't work

echo -e "${COLOR_White}[home-wifi] Setting the essid.${COLOR_off}"
sudo iwconfig wlan0 essid V8XB1

echo -e "${COLOR_White}[home-wifi] Setting the key.${COLOR_off}"
sudo iwconfig wlan0 key 12E5D82969 open

echo -e "${COLOR_White}[home-wifi] Starting things back up.${COLOR_off}"
sudo dhclient wlan0

if [ "`ping -c 1 google.com`" ]
then
    echo -e "${COLOR_IWhite}[home-wifi] Online.${COLOR_off}"
else
    echo -e "${COLOR_IWhite}[home-wifi] Connection FAILED.${COLOR_off}"
fi
