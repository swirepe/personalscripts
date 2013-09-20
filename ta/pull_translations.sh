#!/usr/bin/env bash

if [[ "$PWD" != "$TRTOP" ]]
then
	echo "Run this from TRTOP." > /dev/stderr
	echo "You are at $PWD" > /dev/stderr
	echo "TRTOP is $TRTOP" > /dev/stderr
	exit 1
fi

echo "Be sure to not commit any of these generated properties files."
$PWD/scripts/i18n-dump-to-properties.csh
$PWD/scripts/tweak flush params
echo "Done."
