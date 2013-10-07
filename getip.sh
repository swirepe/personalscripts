#!/usr/bin/env bash
# http://www.unix.com/shell-programming-scripting/159411-parsing-ifconfig-output.html
#ifconfig -a | awk '$2~/^Link/{_1=$1;getline;if($2~/^addr/){print _1" "$2}}'

if [ `uname | awk '{print $1}'` == "Linux" ]
then
    /sbin/ifconfig -a |
    awk '$2~/^Link/{_1=$1;getline;if($2~/^addr/){print _1" "$2}}'
else 
    ifconfig -a |
    awk '$2~/^flags/{_1=$1;getline;if($1~/^inet/){print _1" "$2}}'
fi

echo "ifconfig.me: $(curl ifconfig.me 2>/dev/null)"
echo "ipogre:      $(curl ipv4.ipogre.com 2>/dev/null)"
