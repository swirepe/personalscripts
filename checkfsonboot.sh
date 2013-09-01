#!/usr/bin/env bash
# if this is ubuntu, make fsck run next time you boot
if [[ "$(uname)" != "Linux" ]]
then
    echo "WARNING: This doesn't look like linux." > /dev/stderr
fi

sudo touch /forcefsck
if [ -e /forcefsck ]
then
    echo "/forcefsck exists."
    echo "fsck will be run on next boot."
else
    echo "/forcefsck does NOT exist."
    echo "fsck will NOT be run on next boot."
fi
