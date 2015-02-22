#!/usr/bin/env bash
# http://blog.iangreenleaf.com/2009/03/rsync-and-retrying-until-we-get-it.html
# https://gist.github.com/jmar71n/366269
### ABOUT
### Runs rsync, retrying on errors up to a maximum number of tries.
### Simply edit the rsync line in the script to whatever parameters you need.

DIR_TO_SYNC="~/sftp"
if [[ "$1" ]]
then
	DIR_TO_SYNC="$1"
fi

echo "Syncing $DIR_TO_SYNC"
if [[ ! -d "$DIR_TO_SYNC" ]]
then
	echo "Error: $DIR_TO_SYNC not found." > /dev/stderr
fi

# Trap interrupts and exit instead of continuing the loop
trap "echo Exited! > /dev/stderr ; exit 1;" SIGINT SIGTERM
 
MAX_RETRIES=5000
i=0

echo "Mounting google drive."
google-drive-ocamlfuse /home/swirepe/gdrive || $(echo "Failed to mount /home/swirepe/gdrive" > /dev/stderr && exit 1)


echo "Attempting rsync $*" >/dev/stderr
echo "Maximum attempts: $MAX_RETRIES" >/dev/stderr

RSYNC_STATUS=1 
while [ $RSYNC_STATUS -ne 0 -a $i -lt $MAX_RETRIES ]
do
	i=$(($i+1))
	echo "Attempt $i" > /dev/stderr
	rsync --protocol=26 --size-only --protect-args --partial --recursive --progress --verbose --inplace "$DIR_TO_SYNC" ~/gdrive
	RSYNC_STATUS=$?
	if [ $RSYNC_STATUS -ne 0 ]
	then
		echo "Remounting." > /dev/stderr
		fusermount /home/swirepe/gdrive
		sudo umount /home/swirepe/gdrive &&
		google-drive-ocamlfuse /home/swirepe/gdrive 
	fi
done
 
if [ $i -eq $MAX_RETRIES ]
then
	echo "Hit maximum number of retries, giving up." > /dev/stderr
	exit 1
fi

exit 0
