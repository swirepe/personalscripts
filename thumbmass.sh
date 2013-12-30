#!/usr/bin/env bash

if [[ "$(which parallel)" == "" ]]
then
	echo "Error: gnu parallel not found" > /dev/stderr
	exit 1
fi

(for FILE in $@
do
  echo $FILE  
done) | parallel --progress thumb
