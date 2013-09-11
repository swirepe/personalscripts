#!/usr/bin/env bash

rootdir=$(pwd)

git submodule update --init && (

for submodule in $( git submodule | awk  '{ print $2 ;}' )
do  
    cd $submodule
    echo -n "Checking out master on $submodule: " 
    git checkout master 2>&1
    cd $rootdir
done

)
