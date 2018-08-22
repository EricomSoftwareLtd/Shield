#!/bin/bash
############################################
#####   Ericom Shield Installer        #####
#######################################BH###

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo "Usage: $0 [-force] [-autoupdate] [-staging] [-quickeval] [-usage]"
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

ES_PATH="/usr/local/ericomshield"
if [ -d  "$ES_PATH" ]; then
   cd "$ES_PATH"
fi

if [ -z "$BRANCH" ]; then
    if [ -f "$ES_BRANCH_FILE" ]; then
        BRANCH=$(cat "$ES_BRANCH_FILE")
    else
        BRANCH="master"
    fi
fi

rm ./ericomshield-setup.sh
wget https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/ericomshield-setup.sh
chmod +x ericomshield-setup.sh
bash ./ericomshield-setup.sh $@
