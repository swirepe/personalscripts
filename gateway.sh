#!/usr/bin/env bash

if route -n &>/dev/null
then
    route -n | grep "^0.0.0.0"  | awk '{print $2}'
else
    route -n get default | grep gateway | cut -f2 -d: | sed 's/ //'
fi



