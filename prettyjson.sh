#!/usr/bin/env bash
# http://stackoverflow.com/questions/352098/how-can-i-pretty-print-json-from-the-command-line
for file in $@
do
	cat $file | python -mjson.tool
done
