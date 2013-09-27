#!/usr/bin/env bash

ARG="$1"

for backup_script in $(
        ls $SCRIPTS_DIR/backup-* | 
        grep -v "~"   |
        grep -v "all" |
        grep -v "#"
    )
do
    if [[ -z "$ARG" ]]
    then
        echo "Running $backup_script with no arguments."
    else
        echo "Running $backup_script with argument $ARG"
    fi
	eval $backup_script $1
done
