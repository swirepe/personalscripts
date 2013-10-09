#!/usr/bin/env bash

eval `ssh-agent -s` &> /dev/null
trap "kill $SSH_AGENT_PID" 0
ssh-add $HOME/pers/keys/bitbucket-key
