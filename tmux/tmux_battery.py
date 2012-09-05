#!/usr/bin/python

import math
import re
import sys


def getBatteryInfo():
    infoComponents = open("/proc/acpi/battery/BAT0/info").readlines()

    batteryInfo = dict()
    pattern = re.compile(r":\s+")

    for component in infoComponents:
        name, status = re.split(pattern, component)
        batteryInfo[name.replace(":", '')] = status.rstrip()
        
    return batteryInfo



def getBatteryState():
    stateComponents = open("/proc/acpi/battery/BAT0/state").readlines()
    batteryState = dict()
    
    pattern = re.compile(r":\s+")
    
    for component in stateComponents:
        name, status = re.split(pattern, component)
        batteryState[name.replace(":", '')] = status.rstrip()
        
    return batteryState
        
        
        
def getMaxCapacity(batteryInfo):
    """Returns the capacity in mAh"""
    numPattern = re.compile(r"\d+")
    capacity = re.findall(numPattern, batteryInfo["last full capacity"])[0]
    return int(capacity)


def getCurrentCapacity(batteryState):
    numPattern = re.compile(r"\d+")
    capacity = re.findall(numPattern, batteryState["remaining capacity"])[0]
    return int(capacity)
    

def getCapacityPercent(batteryInfo, batteryState):
    maxCapacity = getMaxCapacity(batteryInfo)
    currentCapacity = getCurrentCapacity(batteryState)

    percentCapacity = 100.0 * currentCapacity / maxCapacity
    
    return percentCapacity
    
    
def styleCapacityPercent(percentCapacity): 
    style = _getStyleFromPercent(percentCapacity)
    return style + ("%0.2f" % percentCapacity) + "%#[default]"


def _getStyleFromPercent(percent):
    style = "#[default]"
    if percent > 98.0:
        style = "#[fg=white bright]#[bg=green]"
    elif percent > 90.0:
        style = "#[fg=green bright]"
    elif percent > 70.0:
        style = "#[fg=green]"
    elif percent > 50.0:
        style = "#[fg=yellow]"
    elif percent > 40.0:
        style = "#[fg=yellow bright]"
    elif percent > 30.0:
        style = "#[fg=red bright]"
    else:
        style = "#[fg=black bright]#[bg=red]"
        
    return style


def getBars(percentCapacity, length=10):
    """
    This will give us a number of bars
    between 0 and length (10 by default)
    a full bar will be a =, a half bar will be a -
    """
    numBars = percentCapacity / 100.0 * length
    
    halfBar = False
    if numBars - math.floor(numBars) >= 0.5:
        numBars = max((numBars - 1, 0))
        halfBar = True
        
    bars = "=" * int(numBars)
    if halfBar:
        bars += "-"
                      
    style = _getStyleFromPercent(percentCapacity)
    
    return style + bars + "#[default]"
    
    



def getCharging(batteryState):
    charging = batteryState["charging state"]
    
    if charging == "discharging":
        charging = "#[fg=red]" + charging + "#[default]"
    elif charging == "charged":
        charging = "#[fg=green]" + charging + "#[default]"

    return charging
        





       
if __name__ == "__main__":
    state = getBatteryState()
    info = getBatteryInfo()
    
    if "charging" in sys.argv:
        print getCharging(batteryState)
        sys.exit(0)
        
    if "capacity-percent" in sys.argv:
        cp = getCapacityPercent(info, state)
        print styleCapacityPercent(cp)
        sys.exit(0)
        
    if "capacity-max" in sys.argv:
        print getMaxCapacity(info)
        sys.exit(0)
        
    if "capacity-current" in sys.argv:
        print getCurrentCapacity(state)
        sys.exit(0)
        
    if "bars" in sys.argv:
        cp = getCapacityPercent(info, state)
        print getBars(cp)
