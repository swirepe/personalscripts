#!/usr/bin/env bash

# on ubuntu, the netflix-desktop program runs way way way too fast
# you can throttle pulseaudio which makes it behave better
# http://hongouru.blogspot.com/2013/06/solved-netflix-desktop-has-choppy-video.html

# my version of cpulimit doesn't specify cores, so
which cpulimit || echo "ERROR: cpulimit must be installed." && exit 1
which netflix-desktop || echo "ERROR: netflix-desktop must be installed" && exit 1

cpulimit -e pulseaudio -l 10 & netflix-desktop
