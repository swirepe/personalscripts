if [[ "$(iwconfig wlan0 | grep -i quality)" == "" ]]
then
    echo -en "✈"
else
   : 
fi



## http://www.cyberciti.biz/tips/linux-find-out-wireless-network-speed-signal-strength.html
