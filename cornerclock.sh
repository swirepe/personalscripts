#!/usr/bin/env bash

if [[ "$1" == "--kill" ]]
then
	kill $(cat /tmp/cornerclock.pid)
	rm /tmp/cornerclock.pid
	exit 0
fi

if [ -e /tmp/cornerclock.pi ]
then
	exit 1
fi

while sleep 1
do 
	tput sc
	tput cup 0 $(($(tput cols)-28))
	date +"%a %b %d %l:%M:%S %p %Y"
	tput rc
done &

CLOCK_PID="$!"

echo "$CLOCK_PID" > /tmp/cornerclock.pid
