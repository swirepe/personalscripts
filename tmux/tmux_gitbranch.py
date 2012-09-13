#!/usr/bin/env screen_python

from collections import defaultdict
import os
import shelve
import subprocess
import sys

def getToDirectory():
    shelfdir = os.path.join(os.environ["SCRIPTS_DIR"], "tmux")
    shelfpath = os.path.join(shelfdir, ".tmux_env.shelf")
    localenv = shelve.open(shelfpath)

    tpane = localenv["TMUX_ACTIVE_PANE"]
    os.chdir(localenv["CWD"][tpane])
    

def getBranch():
    """returns the currently selected branch, excluding the '* ' at the front of it"""
    output,error = subprocess.Popen(["git", "branch"], stdout = subprocess.PIPE, stderr= subprocess.PIPE).communicate()
    
    if error != '':
        return ''
    
    retbranch = "master"

    branches = output.split("\n")
    for branch in branches:
        if branch.startswith("*"):
            retbranch = branch[2:]
            
    return retbranch
            
            
def getStatus():
    """Gets the status in defaultdict(list):
    '??' => [untracked files]
    'M' => [modified files]
    'D' => [deleted files]
    'A' => [added files]
    """
    
    output,error = subprocess.Popen(["git", "status", "-s"], stdout = subprocess.PIPE, stderr= subprocess.PIPE).communicate()
    
    retval = defaultdict(list)
    
    if error != '':
        return retval
        
    statuses = ['??', 'A', 'M', 'D']
    
    outputLines = output.split("\n")
    for line in outputLines:
        try:
            status, f = line.split(" ")
            
            for s in statuses:
                if s in status:
                    retval[s].append(f)
        except:
            pass
        
    return retval
    
    
def reportBranch():
    """Prints the current branch, with colors in this order:
        green if no changes
        cyan if modified files
        magenta if added/deleted files
        white if untracked files
        
    prints an empty string of there is no branch
    """
    getToDirectory()
    
    branch = getBranch()
    if branch == "":
        print '  ----  '
        return
    

    status = getStatus()
    color = "#[fg=green bright]"
    
    if len(status["??"]) != 0:
        color = "#[fg=white]"
    elif len(status['A']) + len(status['D']) != 0:
        color = "#[fg=magenta bright]"
    elif len(status['M']) != 0:
        color = "#[fg=cyan bright]" 
        
        
    print "#[default]" + color + branch + "#[default]"
    
    
# possible problem: this is running in some other directory        
if __name__ == "__main__":
    reportBranch()
