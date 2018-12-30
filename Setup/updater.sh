#!/bin/bash
############################################
#####   Ericom Shield Updater          #####
#######################################BH###

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo "Usage: $0 "
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

ES_PATH="/usr/local/ericomshield"
if [ -d "$ES_PATH" ]; then
    cd "$ES_PATH"
else
    echo "ericomshield directory not found, please install the product first."
    exit
fi

ES_BRANCH_FILE="$ES_PATH/.esbranch"
if [ -f "$ES_BRANCH_FILE" ]; then
    BRANCH=$(cat "$ES_BRANCH_FILE")
else
    BRANCH="master"
fi

rm -f update.sh
wget https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/update.sh
chmod +x update.sh
bash ./update.sh $@
