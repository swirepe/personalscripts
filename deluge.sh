#!/usr/bin/env bash

LD_PRELOAD="" deluge-gtk $@ &> /dev/null &
disown deluge-gtk
