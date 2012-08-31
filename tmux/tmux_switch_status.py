#!/usr/bin/python

import os
import shelve

# get the the right directory, load them in order
os.chdir( os.path.join(os.environ["SCRIPTS_DIR"], "tmux")) 

# use a shelf, because environments are weird here
localenv = shelve.open(".tmux_env.shelf")

try:
    index = localenv["TMUX_CURRENT_STATUS"]
except KeyError:
    index = 0


statuses = os.listdir("./status")


if index >= len(statuses):
    index = 0
    
    
newstat = statuses[index]

# write the contents to the file that'll be sourced by tmux.conf
instat = open("./status/" + newstat, 'r').readlines()
outstat = open("./current.tmux_status", 'w')
outstat.write("".join(instat))

outstat.close()


# update the environment
localenv["TMUX_CURRENT_STATUS"] = index + 1
localenv.close()
