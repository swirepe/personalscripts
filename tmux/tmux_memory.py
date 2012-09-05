#!/usr/bin/python

import re

def getMemoryInfo():
    memlines = open("/proc/meminfo").readlines()
    
    meminfo = dict()
    
    pattern = re.compile(r":\s+")
    for line in memlines:
        name, value = re.split(pattern, line)
        
        meminfo[name.replace(":", '')] = value.rstrip()
        
    return meminfo
    
    
# TODO: find a nice suitable bar and color it
