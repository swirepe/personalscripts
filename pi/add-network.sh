#!/usr/bin/env bash

function add_ssh {
    echo -e "$1" | tee --append ~/.ssh/config
    
}

function add_host {
    NAME="$1"
    IP="$2"
    if [[ -z "$(grep $NAME /etc/hosts)" ]]
    then
        echo -e "${IP}\t${NAME}" | sudo tee --append /etc/hosts
    fi
}

function ssh_host {
    H="$1"
    U="$2"
    if [[ -z "$U" ]]
    then
        U="swirepe"
    fi
    if [[ -z "$(grep $H ~/.ssh/config)" ]]
    then
        echo "Host $H"
        echo "    User $U"
        echo "    Hostname $H"
        echo "    Port 212"
        echo -e "\n"
    fi
}

add_ssh "\n\n## ---------------------------------------"
add_ssh "## added on $(date) by add-network.sh"

add_ssh $(ssh_host "betta")
add_ssh $(ssh_host "ray")
add_ssh $(ssh_host "smokeshark")
add_ssh $(ssh_host "snake" "root")
add_ssh $(ssh_host "warmouth")

echo "\n\n## ---------------------------------------\n## added on $(date) by add-network.sh" | sudo tee --append /etc/hosts
add_host "betta"    "192.168.1.101"
add_host "ray"      "192.168.1.102"
add_host "smokeshark"      "192.168.1.103"
add_host "snake"    "192.168.1.104"
add_host "warmouth" "192.168.1.105"

echo "## ---------------------------------------" | sudo tee --append /etc/hosts
