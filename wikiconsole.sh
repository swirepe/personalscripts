#!/bin/sh
# give you a wikipedia summary of whatever
dig +short txt ${1}.wp.dg.cx | fold -s
