#!/usr/bin/env bash

echo "Today In history, $(date +'%B_%-d'):"

# between events and births
# remove brackets
# put stars at the front
# remove the lines events and births
# join all the lines together with spaces
# remove duplicate spaces
# replace stars with newlines and stars
# remove blank lines
# join them all together

if [ ! -e /tmp/today_in_history_$(date +'%B_%-d') ]
then
    lynx -dump "http://en.wikipedia.org/wiki/$(date +'%B_%-d')" > /tmp/today_in_history_$(date +'%B_%-d')
fi

cat /tmp/today_in_history_$(date +'%B_%-d') |
sed -n '/^Events/,/^Births/p' |
sed 's/\[.*\]//g' |
sed -e 's/^\s*\*/\*/' |
sed 's/^Events.*//;s/^Births.*//' |
paste -s -d ' ' -  |
sed -e 's/\s\s*/ /g' |
sed 's/\*/\n\*/g' |
sed '/^$/d' |
chooseln
