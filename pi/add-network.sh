#!/usr/bin/env bash


function add_host {
    NAME="$1"
    IP="$2"
    if [[ -z "$(grep $NAME /etc/hosts)" ]]
    then
        echo -e "${IP}\t${NAME}" | sudo tee --append /etc/hosts
    fi
}


function ssh_host {
    plain_ssh_host $@
    remote_ssh_host $@
    
}


function plain_ssh_host {
    H="$1"
    U="$2"
    if [[ -z "$U" ]]
    then
        U="swirepe"
    fi
    if [[ -z "$(grep $H ~/.ssh/config)" ]]
    then
        echo "Host $H"            | tee --append ~/.ssh/config
        echo "    User $U"        | tee --append ~/.ssh/config
        echo "    Hostname $H"    | tee --append ~/.ssh/config
        echo "    Port 212"       | tee --append ~/.ssh/config
        echo -e "\n"              | tee --append ~/.ssh/config
    fi
}


function remote_ssh_host {
    H="$1"
    U="$2"
    if [[ -z "$U" ]]
    then
        U="swirepe"
    fi
    if [[ -z "$(grep r$H ~/.ssh/config)" ]]
    then
        echo "Host r$H"            | tee --append ~/.ssh/config
        echo "    User $U"         | tee --append ~/.ssh/config
        echo "    Hostname $H"     | tee --append ~/.ssh/config
        echo "    Port 212"        | tee --append ~/.ssh/config
        echo "    ProxyCommand  ssh -p 212 swirepe@neuroky.me nc %h %p 2> /dev/null" | tee --append ~/.ssh/config
        echo -e "\n"               | tee --append ~/.ssh/config
    fi    
    
    
}



echo -e "\n\n## ---------------------------------------" | tee --append ~/.ssh/config
echo -e "## added on $(date) by add-network.sh"          | tee --append ~/.ssh/config

ssh_host "betta"
ssh_host "ray"
ssh_host "smokeshark"
ssh_host "snake" "root"
ssh_host "warmouth"

echo  "## ---------------------------------------" | tee --append ~/.ssh/config


echo -e "\n\n## ---------------------------------------\n## added on $(date) by add-network.sh" | sudo tee --append /etc/hosts
add_host "betta"    "192.168.1.101"
add_host "ray"      "192.168.1.102"
add_host "smokeshark"      "192.168.1.103"
add_host "snake"    "192.168.1.104"
add_host "warmouth" "192.168.1.105"

echo "## ---------------------------------------" | sudo tee --append /etc/hosts
