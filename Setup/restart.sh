#!/bin/bash
############################################
#####   Ericom Shield Restart          #####
#######################################BH###

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

ES_PATH=/usr/local/ericomshield
echo "***********       Restarting EricomShield "
echo "***********       "
echo "*******       Stopping EricomShield "
$ES_PATH/stop.sh
echo "done"

echo "*******       Starting EricomShield "
sleep 30
$ES_PATH/run.sh
echo "done"
