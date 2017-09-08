#!/bin/bash
############################################
#####   Ericom Shield Run              #####
#######################################BH###

ES_PATH=/usr/local/ericomshield

#Check if we are root
if (($EUID != 0)); then
    #    sudo su
    echo " Please run it as Root"
    echo "sudo" $0 $1 $2
    exit
fi
cd $ES_PATH

echo "Running deploy-shield.sh:"
./deploy-shield.sh
