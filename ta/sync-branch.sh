#!/usr/bin/env bash

BRANCH="$1"

if [[ -z "$BRANCH" ]]
then
    echo "Usage: $0 trsrc-MAINLINE      Synchronize all changes to trsrc-MAINLINE on the laptop to the devserver"
    echo "ERROR: empty branch" > /dev/stderr
    exit 1
fi


if [ ! -e /Users/swirepe/pers/scripts/src/fswatch/fswatch ]
then
    echo "ERROR: fswatch not at /Users/swirepe/pers/scripts/src/fswatch/fswatch" > /dev/stderr
    exit 1
fi



if [[ -d /Users/swirepe/$BRANCH ]]
then
    echo "local: /Users/swirepe/$BRANCH"
else
    echo "ERROR: local path /Users/swirepe/$BRANCH doesn't exist" > /dev/stderr
    exit 1
fi


if [[ $(ssh pswire-dev test -d /home/site/$BRANCH && echo exists) ]]
then
    echo "remote: pswire@pswire-dev:home/site/$BRANCH"
else
    echo "ERROR remote path pswire@pswire-dev:home/site/$BRANCH doesn't exist" > /dev/stderr 
    exit 1
fi




echo "Synching $BRANCH"
/Users/swirepe/pers/scripts/src/fswatch/fswatch /Users/swirepe/$BRANCH rsync --verbose --archive --filter="+ *.java" --filter="+ *.vm" --filter="+ *.css" --filter="+ *.js" --filter="+ */" --filter="- *" /Users/swirepe/$BRANCH pswire-devserver:/home/site/$BRANCH
