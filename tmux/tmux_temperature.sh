#!/usr/bin/env bash

for therm in $(ls -d /sys/class/thermal/thermal_zone*/)
do  
    THERM_ID="$(basename $therm | tr -cd '0-9\012')"
    X=$(cat $therm/temp)
    FARENHEIGHT=$( echo "scale=2; $X / 1000.0 * 9 / 5 + 32" | bc -l)
    echo -n "${THERM_ID}:${FARENHEIGHT}°F "
done
