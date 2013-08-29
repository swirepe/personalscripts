#!/bin/bash
pushd .
echo -e "${COLOR_BBlue}Building.${COLOR_off}"
cd $TRTOP
echo -e "${COLOR_BBlue}Currently in $(pwd)${COLOR_off}" 
make -C config/  &&
make -C config/webserver &&
sudo make &&
echo -e "${COLOR_BBlue}Bouncing.${COLOR_off}" &&
$TRTOP/scripts/tabuild -rdf 
popd
