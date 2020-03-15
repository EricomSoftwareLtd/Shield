#!/bin/bash
############################################
#####   Ericom Shield Installer        #####
#######################################BH###

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

ES_PATH="$HOME/ericomshield"
if [ -d  "$ES_PATH" ]; then
   cd "$ES_PATH"
fi

ES_BRANCH_FILE="$ES_PATH/.esbranch"
if [ -z "$BRANCH" ]; then
    if [ -f "$ES_BRANCH_FILE" ]; then
        BRANCH=$(cat "$ES_BRANCH_FILE")
    else
        BRANCH="master"
    fi
fi

rm ./install-shield.sh
wget https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/install-shield.sh
chmod +x install-shield.sh
bash ./install-shield.sh $@
