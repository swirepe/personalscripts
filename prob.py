#!/usr/bin/python
from random import random
import sys

# Exits successfully p percent of the time

p = 0.5
if len(sys.argv) > 1:
    p = float(sys.argv[1])

if random() < p:
    sys.exit(0)
sys.exit(1)

