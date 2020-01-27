#!/bin/bash
############################################
#####   Ericom Shield Run              #####
#######################################BH###

ES_PATH="$HOME/ericomshield"
LOGFILE="$ES_PATH/ericomshield.log"

cd "$ES_PATH" || exit 1

echo "***********       Deploying Ericom Shield "
echo "***********       "
echo "$(date): Deploying Ericom Shield" >>"$LOGFILE"

$ES_PATH/deploy-shield.sh -L .
echo "done"

