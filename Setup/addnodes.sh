#!/bin/bash
############################################
#####   Ericom Shield AddNode          #####
#######################################LO###

ES_PATH=/usr/local/ericomshield
ES_VER_FILE="./shield-version.txt"
LOGFILE="$ES_PATH/ericomshield.log"
COMMAND_NAME="$0"
UPDATE_LOG_FILE="$ES_PATH/lastoperation.log"

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi
cd $ES_PATH

echo "Running  $0:"

if [ ! -f "$ES_VER_FILE" ]; then
   echo "$(date): Ericom Shield Update: Cannot find version file" >>"$LOGFILE"   
   exit 1
fi

CONTAINER_TAG="$(grep -r 'shield-autoupdate' $ES_VER_FILE | cut -d' ' -f2)"
if [ "$CONTAINER_TAG" = "" ]; then
   CONTAINER_TAG="shield-autoupdate:180503-10.48-1953"
fi

docker run --rm  -it \
       -v /var/run/docker.sock:/var/run/docker.sock \
       -v $(which docker):/usr/bin/docker \
       -v "$ES_PATH:/usr/local/ericomshield" \
       -e "ES_PRE_CHECK_FILE=$ES_PRE_CHECK_FILE" \
       -e "COMMAND=$COMMAND_NAME" \
       "securebrowsing/$CONTAINER_TAG addnode" "${@}"
