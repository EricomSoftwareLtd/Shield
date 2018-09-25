#!/bin/bash
############################################
#####   Ericom Shield Update           #####
###################################LO##BH###

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo "Usage: $0 [OPTIONS] COMMAND [ARGS]..."
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

BRANCH="master"
ES_PATH=/usr/local/ericomshield

if [ -f "$ES_PATH/.esbranch" ]; then
    BRANCH=$(cat "$ES_PATH/.esbranch")
fi

source "$ES_PATH/ericomshield-repo.sh"

MAIN_SCRIPT_URL="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/update.py"

cd "$ES_PATH"

curl -s -S -o "update.py" $MAIN_SCRIPT_URL

python update.py "${@}"

