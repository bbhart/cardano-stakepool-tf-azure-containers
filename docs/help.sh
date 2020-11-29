#!/bin/bash

if [ "$1" == "-h" ] ; then
    cat << EndOfMessage
Usage:
./run.sh [environment] [init|destroy]
e.g.
./run.sh dev init
./run.sh dev destroy
EndOfMessage
    exit 0
fi