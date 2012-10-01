if [[ "$(iwconfig wlan0 | grep -i quality)" == "" ]]
then
    echo -en "✈"
else
   : 
fi

