#!/bin/bash
############################################
#####   Ericom Shield Restart          #####
#######################################BH###

ES_PATH=/usr/local/ericomshield
LOGFILE="$ES_PATH/ericomshield.log"
STACK_NAME=shield

function show_usage() {
    echo "Restart Ericom Shield"
    echo "Usage: $0 "
    exit
}

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo " Please run it as Root"
    echo "sudo $0 $@"
    show_usage
    exit
fi

if [ ! -z $1 ]; then
    show_usage
fi

ES_PATH=/usr/local/ericomshield
echo "***********       Restarting EricomShield "
echo "***********       "
echo "*******       Stopping EricomShield "
$ES_PATH/stop.sh
echo "done"

echo "*******       Starting EricomShield "
$ES_PATH/start.sh
echo "done"
