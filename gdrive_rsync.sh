#!/usr/bin/env bash
# http://blog.iangreenleaf.com/2009/03/rsync-and-retrying-until-we-get-it.html
# https://gist.github.com/jmar71n/366269
### ABOUT
### Runs rsync, retrying on errors up to a maximum number of tries.
### Simply edit the rsync line in the script to whatever parameters you need.
 
# Trap interrupts and exit instead of continuing the loop
trap "echo Exited! > /dev/stderr ; exit 1;" SIGINT SIGTERM
 
MAX_RETRIES=5000
i=0

echo "Attempting rsync $*" >/dev/stderr
echo "Maximum attempts: $MAX_RETRIES" >/dev/stderr

# Set the initial return value to failure
false
 
while [ $? -ne 0 -a $i -lt $MAX_RETRIES ]
do
    i=$(($i+1))
    echo "Attempt $i" > /dev/stderr
		sudo umount /home/swirepe/gdrive &&
		google-drive-ocamlfuse /home/swirepe/gdrive &&
    rsync --partial --archive --progress --verbose --inplace ~/sftp ~/gdrive
done
 
if [ $i -eq $MAX_RETRIES ]
then
    echo "Hit maximum number of retries, giving up." > /dev/stderr
    exit 1
fi

exit 0
