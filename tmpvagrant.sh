#!/usr/bin/env bash


DIRNAME="$(mktemp -d vagrant.XXXXX)"
cd $DIRNAME
vagrant init lucid32
vagrant up
vagrant ssh
vagrant halt
vagrant destroy
cd .. 
rm -rf "$DIRNAME"
