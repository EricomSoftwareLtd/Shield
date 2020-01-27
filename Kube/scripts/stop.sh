#!/bin/bash
############################################
#####   Ericom Shield Stop             #####
#######################################BH###

ES_PATH="$HOME/ericomshield"
LOGFILE="$ES_PATH/ericomshield.log"

cd "$ES_PATH" || exit 1

echo "***********       Stopping Ericom Shield "
echo "***********       "
echo "$(date): Stopping Ericom Shield" >>"$LOGFILE"

./delete-shield.sh -s -k

echo "done"
