#!/usr/bin/env bash
# this program just makes 127.0.0.2 part of the loopback too
# use it for distractingsites
sudo ifconfig lo0 alias 127.0.0.2 up

for i in {2..254}
do
    sudo ifconfig lo0 alias 127.0.0.$i up
    
done
