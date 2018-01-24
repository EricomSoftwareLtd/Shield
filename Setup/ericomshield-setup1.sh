#!/bin/bash
############################################
#####   Ericom Shield Setup            #####
#####  for Backup Compatibility        #####
#######################################BH###

ES_PATH="/usr/local/ericomshield"

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

if [ -z "$BRANCH" ]; then
    BRANCH="master"
fi

# Setup File
ES_repo_setup="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/ericomshield-setup.sh"
cd $ES_PATH
curl -s -S -o setup.sh $ES_repo_setup
chmod +x setup.sh
$ES_PATH/setup.sh  $@
