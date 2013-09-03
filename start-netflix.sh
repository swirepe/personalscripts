#!/usr/bin/env bash

# on ubuntu, the netflix-desktop program runs way way way too fast
# you can throttle pulseaudio which makes it behave better
# http://hongouru.blogspot.com/2013/06/solved-netflix-desktop-has-choppy-video.html

# my version of cpulimit doesn't specify cores, so
which cpulimit || ( echo "Installing cpulimit" && sagi cpulimit )
which netflix-desktop || ( echo "Installing netflix-desktop" && sudo apt-add-repository ppa:ehoover/compholio && sagi netflix-desktop ) 

cpulimit -e pulseaudio -l 10 & netflix-desktop
