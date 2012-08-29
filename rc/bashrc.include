#!/usr/bin/python
import argparse
from collections import defaultdict
import ConfigParser
import subprocess
import sys


"""
source $BASHINCLUDES_DIR/cudaenvs.sh
source $BASHINCLUDES_DIR/misc.sh
source $BASHINCLUDES_DIR/navigation.sh
source $BASHINCLUDES_DIR/projects.sh
source $BASHINCLUDES_DIR/prompts.sh
source $BASHINCLUDES_DIR/screens.sh
source $BASHINCLUDES_DIR/virtualenvs.sh
"""

def error(e):
    print >> sys.stderr, e


def getArguments():
    parser = argparse.ArgumentParser(description="A utility for 'including' bash files in other bash files.")
    
    parser.add_argument("-L", "--list", dest="includeList", nargs='+', default=[], help="Load the shell scripts by path from a text file, one per line.")
    parser.add_argument("-d", "--depends", nargs='+', default=[], help="Read the dependencies from an external file.")
    parser.add_argument("-f", nargs="+", default=[], help="The files to include.")
    
    args = parser.parse_args()
    
    return args
    
    
def processArgs():
    args = getArguments()
    files = []
    
    files.extend(args.f)
    for L in args.includeList:
        files.extend( readList(L) )

    deps = getDependencies(files, args.depends)


def readList(includeList):
    try:
        f = open(includeList, 'r')
        return f.readlines()
    except:
        error('Error reading ' + str(includeList))
        return []



def getDependencies(files, dependsFiles):
    """get the depencies for each file.
    In the files themselves, they will be listed on lines
    starting with #^, one per line
    
    in the dependency files, they will be in config file format"""
    
    # file -> [files that need to be run first]
    deps = defaultdict(list)

    _deps_from_files(deps, files)
    _deps_from_deps_files(deps, dependsFiles, files)



def _deps_from_files(deps, files):
    # mutates the defaultdict deps in place
    for fname in files:
        f = open(fname)
        for line in f.readlines():
            if line.startswith("#^"):
                line = line[2:]
                line = line.lstrip().rstrip()
                deps[fname].append(line)
            


def _deps_from_deps_files(deps, dependsFiles, files):
    config = ConfigParser.ConfigParser(allow_no_value=True)
    for section in config.sections():
        if section not in files:
            error("Warning: dependency found for unspecified file: " + str(section))
            continue
            
        items = [dep for (dep, _) in config.get(section)]
        deps[section].extend(items)
        

print getArguments()
