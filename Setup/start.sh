#!/bin/bash
############################################
#####   Ericom Shield Run              #####
#######################################BH###

function show_usage() {
    echo "Start Ericom Shield"
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
cd $ES_PATH

echo "Running deploy-shield.sh:"
./deploy-shield.sh
