#!/bin/sh
logger Starting rsync of /usr/local/tripadvisor/fbrs/
rsync --archive --delete --update fbr01n::local/fbrs/1/ /usr/local/tripadvisor/fbrs/
exit_status=$?
if [ $exit_status -eq 0 ]
then
    logger rsync complete for /usr/local/tripadvisor/fbrs/
else
    logger rsync failed!! for /usr/local/tripadvisor/fbrs/
    mail -s "Rsync of FBRS failed with status $exit_status" swirepe@localhost < /dev/null
fi

