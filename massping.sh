#!/usr/bin/env bash

if [[ "$1" == "--ping" ]]
then
    IP="$2"
    ping -c 1 $IP &> /dev/null && echo -e "${IP}\tOK"
else

CLIPPED_GATEWAY=$(gateway.sh | cut -f1,2,3 -d.)    
seq 1 254 | sed 's/^/'"${CLIPPED_GATEWAY}"'./' | parallel $0 --ping '{}' 
    
#CLIPPED_GATEWAY=$(gateway.sh | cut -f1,2,3 -d.)
#for IP in $(seq 1 254 | sed 's/^/'"${CLIPPED_GATEWAY}"'./')
#do
#    # cleverly wrapping this in a subshell to prevent those notifications
#    $(ping -c 1 $IP &> /dev/null && echo -e "${IP}\tOK" &)
#fi
#sem --wait
