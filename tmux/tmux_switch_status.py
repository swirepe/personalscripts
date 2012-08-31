#!/usr/bin/python

import os
from random import choice

# get the the right directory
os.chdir( os.path.join(os.environ["SCRIPTS_DIR"], "tmux")) 

statuses = os.listdir("./status")

newstat = choice(statuses)

instat = open("./status/" + newstat, 'r').readlines()
outstat = open("./current.tmux_status", 'w')
outstat.write("".join(instat))

outstat.close()
