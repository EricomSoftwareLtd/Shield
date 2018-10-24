#!/bin/bash -e
###########################################
#####   Ericom Shield Addnodes        #####
###################################LO#####

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo "Usage: $0 [OPTIONS] COMMAND [ARGS]..."
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

BRANCH="master"
export ES_PATH=/usr/local/ericomshield
export APP_NAME="$0"
export ES_VER_FILE="$ES_PATH/shield-version.txt"
export ES_PRE_CHECK_FILE="$ES_PATH/shield-pre-install-check.sh"

if [ -f "$ES_PATH/.esbranch" ]; then
    BRANCH=$(cat "$ES_PATH/.esbranch")
fi

cd "$ES_PATH"
MAIN_SCRIPT_URL="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/addnodes.py"
RETURN_CODE=$(curl -so /dev/null -w '%{response_code}' "$MAIN_SCRIPT_URL")

if [ "$RETURN_CODE" != "200" ]; then
   echo "Branch $BRANCH does not exists"
   exit 1
fi


ARGS="${@}"

SCRIPT="python3 ./addnodes.py"
$SCRIPT $ARGS