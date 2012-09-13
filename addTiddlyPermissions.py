#!/usr/bin/python

import argparse
import ConfigParser
import logging
import os
import sys
import time

TIDDLY_PATH = "/home/swirepe/Dropbox/work-wiki/wiki.html"
FIREFOX_PROFILES_PATH = "~/.mozilla/firefox/"


LOGGER = logging.getLogger(sys.argv[0])
LOGGER.addHandler( logging.NullHandler() )



def setupLogging():
    global LOGGER
    
    consoleHandler = logging.StreamHandler(sys.stdout)
    formatter = logging.Formatter("[Tiddly] %(levelname)-7.7s %(message)s")
    consoleHandler.setFormatter(formatter)
    LOGGER.addHandler( consoleHandler )
    LOGGER.setLevel(logging.DEBUG)
    


def getOptions():
    global TIDDLY_PATH
    global FIREFOX_PROFILES_PATH
    
    parser = argparse.ArgumentParser(description="Add TiddlyWiki permissions to firefox profiles.")
    parser.add_argument("-t", "--tiddlywiki-path", type=str, default=TIDDLY_PATH, dest="tiddly_path", help="The path to your local Tiddlywiki html file.")
    parser.add_argument("-f", "--firefox-profile-path", type=str, default=FIREFOX_PROFILES_PATH, dest="profile_path", help="The path to your firefox profiles folder.")

    args = parser.parse_args()
    formatOptions(args.tiddly_path, args.profile_path)
    
    
    

def formatOptions(tiddlyPath, profilePath):
    global TIDDLY_PATH
    global FIREFOX_PROFILES_PATH
    global LOGGER
    
    TIDDLY_PATH = os.path.expanduser( tiddlyPath )
    FIREFOX_PROFILES_PATH = os.path.expanduser( profilePath )
    
    checkValid()
    
    if not TIDDLY_PATH.startswith("file"):
        TIDDLY_PATH = "file://" + TIDDLY_PATH
    
    LOGGER.info("Using tiddlywiki path: %s", TIDDLY_PATH)
    LOGGER.info("Using firefox profile path: %s", FIREFOX_PROFILES_PATH)



def checkValid():
    global TIDDLY_PATH
    global FIREFOX_PROFILES_PATH
    global LOGGER
    
    invalid = False
    if not os.path.exists(TIDDLY_PATH):
        LOGGER.error("Tiddlywiki path does not exist: %s", TIDDLY_PATH)
        invalid = True
        
    if not os.path.exists(FIREFOX_PROFILES_PATH):
        LOGGER.error("Firefox Profile path does not exist: %s", FIREFOX_PROFILES_PATH)
        invalid = True
        
    if invalid:
        LOGGER.error("Invalid configuration. Halting.")
        sys.exit(1)
        


def isFirefoxRunning():
    global LOGGER
    
    try:
        import psutil
    except:
        LOGGER.warning("Cannot import module psutil.  Make sure firefox is not running on your own.")
        return
    
    try:
        runningProcesses = psutil.get_process_list()
        for process in runningProcesses:
            if process.name == 'firefox':
                LOGGER.error("Firefox is running. Aborting.")
                sys.exit(1)
    except:
        pass
    LOGGER.info("No firefox process found. (That's a good thing!)")


def getProfileNames():
    """Open up the profiles.ini file, find the names of the profiles"""
    global FIREFOX_PROFILES_PATH
    global LOGGER
    
    path = os.path.join(FIREFOX_PROFILES_PATH, "profiles.ini")
    
    if os.path.exists(path):
        LOGGER.info("Scraping profiles from profiles.ini: %s", path)
    else:
        LOGGER.error("No profiles.ini found: %s", path)
        sys.exit(1)

    config = ConfigParser.ConfigParser()
    config.read(path)

    sections = config.sections()
    
    names = []
    for section in sections:
        try:
            names.append( config.get(section, 'Name') )
            LOGGER.info("Found profile: %s", names[-1])
        except:
            pass
        
    return names



def addToPrefjs(names):
    global FIREFOX_PROFILES_PATH
    global LOGGER
    
    path = FIREFOX_PROFILES_PATH
    pathListing = os.listdir(path)
    
    for p in pathListing:
        base = os.path.basename(p)
        if isProfile(base, names): 
            appendCommand( os.path.join(FIREFOX_PROFILES_PATH, p, "prefs.js") )



def isProfile(p, names):
    for name in names:
        if p in name or name in p:
            return True
    
    return False



def appendCommand(prefFilePath):
    global TIDDLY_PATH
    global LOGGER
    
    if os.path.exists(prefFilePath):
        LOGGER.info("Found prefs.js at: %s", prefFilePath)
    else:
        LOGGER.warning("No prefs.js at: %s", prefFilePath)
        return
    
    prefFile = open(prefFilePath, 'a')
    
    header = "\n\n// Added by %s (%s)\n" % (sys.argv[0],  time.strftime("%Y-%m-%d %H:%M:%S ", time.localtime()))
    
    prefFile.write(header)

    prefFile.write('user_pref("capability.principal.tiddlywiki.granted", "UniversalXPConnect");\n')
    prefFile.write(('user_pref("capability.principal.tiddlywiki.id", "%s");' % TIDDLY_PATH))

    prefFile.write(("\n// end of content added by %s\n\n" % sys.argv[0]))
    
    prefFile.close()
    
    LOGGER.info("Wrote to user preferences file: %s", prefFilePath)



if __name__ == "__main__":
    setupLogging()
    getOptions()
    isFirefoxRunning()
    profiles = getProfileNames()
    addToPrefjs(profiles)
