#!/usr/bin/env bash


# for ip in $(live_ips)
# do
#     ip=$(to_host $ip)
#     echo -n "$ip "
#     ssh $ip netspeed
#     
# done


if ! which netspeed &> /dev/null
then
    echo "Error: netspeed needs to be in path." >/dev/stderr
    exit 1
fi
    
if ! which gateway.sh &> /dev/null
then
    echo "Error: gateway.sh needs to be in path." >/dev/stderr
    exit 1
fi

function to_host {
    IP="$1"
    HOST=$(grep $IP /etc/hosts | awk '{print $2}')
    if [[ -z "$HOST" ]]
    then
        echo $IP
    else
        echo "$HOST"
    fi
}


function ping_and_ssh {
    $HOST="$(to_host $1)"
    CMD="$2"
    
    echo -en "${HOST}\t"
    if ping -c 1 $HOST &> /dev/null 
    then
        cat $(which netspeed) | ssh $HOST 
    else
        echo "FAIL"
    fi

    
}



for IP in $(lslan)
do
    ping_and_ssh $IP
done



