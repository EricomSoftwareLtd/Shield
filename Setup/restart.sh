#!/bin/bash
############################################
#####   Ericom Shield Restart          #####
#######################################BH###

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
