#!/usr/bin/python

"""
Returns the date and time, with the time being bright red after 5pm and before 7am
"""

import time

now = time.localtime()

style = "#[fg=yellow]"
if now.tm_hour >= 17 or now.tm_hour <= 7:
    style = "#[default]#[fg=red bright]"

ampm = "am"
if now.tm_hour >= 12:
    ampm = "pm"

nowstr = style + str(now.tm_hour % 12) + ":" + str(now.tm_min).zfill(2) + ampm + "#[default]"

print nowstr
