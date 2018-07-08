#!/bin/bash
############################################
#####   Ericom Shield AddNode          #####
#######################################LO###

ES_PATH=/usr/local/ericomshield
ES_VER_FILE="./shield-version.txt"
LOGFILE="$ES_PATH/ericomshield.log"
COMMAND_NAME="$0"
UPDATE_LOG_FILE="$ES_PATH/lastoperation.log"
CONTAINER_TAG_DEFAULT="shield-autoupdate:180628-09.37-2461"

ARGS="addnode"
COMMAND_LINE="${@}"

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

case "${COMMAND_LINE[@]}" in
*"addnode"*)
    ARGS=""
    ;;
esac

cd $ES_PATH

echo "Running  $0:"

if [ ! -f "$ES_VER_FILE" ]; then
    echo "$(date): Ericom Shield Update: Cannot find version file" >>"$LOGFILE"
    exit 1
fi

CONTAINER_TAG="$(grep -r 'shield-autoupdate' $ES_VER_FILE | cut -d' ' -f2)"
if [ "$CONTAINER_TAG" = "" ]; then
    echo "$(date): Warning: shield-autoupdate not found in $ES_VER_FILE, using default tag" >>"$LOGFILE"
    CONTAINER_TAG="$CONTAINER_TAG_DEFAULT"
fi

if [ -f "$UPDATE_LOG_FILE" ]; then
    rm -f $UPDATE_LOG_FILE
fi

echo "***************     Ericom Shield Update ($CONTAINER_TAG $ARGS ${@}) ..."

docker run --rm -it \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $(which docker):/usr/bin/docker \
    -v "$ES_PATH:/usr/local/ericomshield" \
    -e "ES_PRE_CHECK_FILE=$ES_PRE_CHECK_FILE" \
    -e "COMMAND=$COMMAND_NAME" \
    "securebrowsing/$CONTAINER_TAG" $ARGS ${@}
