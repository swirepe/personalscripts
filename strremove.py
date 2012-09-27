#!/usr/bin/python
# because i suck at sed.
# used in alwaysontop for removing indicators from prompts

import sys

base = sys.argv[1]
toRemove = sys.argv[2]

sys.stdout.write( base.replace(toRemove, "") )
