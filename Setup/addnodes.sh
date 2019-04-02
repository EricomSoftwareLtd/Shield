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
DOCKER_USER="ericomshield1"
DOCKER_SECRET="Ericom98765$"

if [ -f "$ES_PATH/.esbranch" ]; then
    BRANCH=$(cat "$ES_PATH/.esbranch")
fi

function docker_login() {
    echo "$DOCKER_SECRET" | docker login --username=$DOCKER_USER --password-stdin
}

if [ ! -d ~/.docker ]; then
   if [ -d /root/.docker ]; then
      CURRENT_USERNAME=$(whoami)
      cp -r /root/.docker ~/
      chown -R $CURRENT_USERNAME:$CURRENT_USERNAME ~/.docker
   else
       docker_login
   fi
fi

cd "$ES_PATH"
MAIN_SCRIPT_URL="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/addnodes.py"
RETURN_CODE=$(curl -so ./addnodes.py -w '%{response_code}' "$MAIN_SCRIPT_URL")

if [ "$RETURN_CODE" != "200" ]; then
    echo "Error: Cannot find addnodes.py in branch: $BRANCH"
    exit 1
fi

ARGS="${@}"

SCRIPT="python3 ./addnodes.py"
$SCRIPT $ARGS
