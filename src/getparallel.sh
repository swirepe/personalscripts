#!/usr/bin/env bash

echo -e "${COLOR_Blue}Fetching and installing gnu parallel.${COLOR_off}"
cd /tmp
wget http://ftp.gnu.org/gnu/parallel/parallel-latest.tar.bz2
tar -xvjf parallel-latest.tar.bz2
cd parallel*
./configure
make
sudo make install
echo -e "${COLOR_BGreen}Install of gnu parallel complete.${COLOR_off}"
