#!/usr/bin/env bash

free -m | grep Mem | awk '{print "Mem Free:", $4 / $2 * 100  "%", "("$4 "M)"}'
