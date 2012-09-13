#!/usr/bin/python

import os
import shelve

shelfdir = os.path.join(os.environ["SCRIPTS_DIR"], "tmux")
shelfpath = os.path.join(shelfdir, ".tmux_env.shelf")

localenv = shelve.open(shelfpath)

tpane = os.environ["TMUX_PANE"]

localenv["TMUX_ACTIVE_PANE"] = tpane
localenv["CWD"] = {tpane: os.getcwd()}
