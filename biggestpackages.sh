#!/usr/bin/env bash

for pkgname in $(apt-cache pkgnames)
do
	SIZE="$(apt-cache show $pkgname | grep Installed-Size | cut -f2 -d: | numfmt --to=iec)"
	echo -e "${SIZE}\t${pkgname}"
done | sort -h 
