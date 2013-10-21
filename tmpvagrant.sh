#!/usr/bin/env bash

BOX="$1"
if [[ $BOX == "--list" ]]
then
    vagrant box list
    exit 0
elif [[ -z $BOX ]]
then
    BOX="lucid64"
fi

echo "Using box $BOX" > /dev/stderr
DIRNAME="$(mktemp -d vagrant.XXXXX)"
cd $DIRNAME
echo "Using temorary directory $DIRNAME" > /dev/stderr
vagrant init $BOX
vagrant up
vagrant ssh
vagrant halt
vagrant destroy
cd .. 
rm -rf "$DIRNAME"
