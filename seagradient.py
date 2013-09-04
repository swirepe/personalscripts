#!/usr/bin/env python

import fileinput
import sys

def colorGen(colorList):
    i = 0
    while True:
        yield colorList[i]
        i += 1
        if i >= len(colorList):
            i = 0


COLOR_IPurple='\033[0;95m'      # Purple
COLOR_IBlue='\033[0;94m'        # Blue
COLOR_ICyan='\033[0;96m'        # Cyan
COLOR_Purple='\033[0;35m'       # Purple
COLOR_Blue='\033[0;34m'         # Blue

colors = [eval(color) for color in dir() if "COLOR" in color]


for color, line in zip( colorGen(colors), fileinput.input()):
    sys.stdout.write(color + line)
