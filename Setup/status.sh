#!/bin/bash
############################################
#####   Ericom Shield Status           #####
#######################################BH###

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo " Please run it as Root"
    echo "sudo" $0 $1 $2
    exit
fi

ES_PATH=/usr/local/ericomshield
cd $ES_PATH
ES_VER_FILE="$ES_PATH/shield-version.txt"

NUM_EXPECTED_SERVICES=$(grep -c image docker-compose.yml)
NUM_RUNNING_SERVICES=$(docker service ls | wc -l)
NUM_EXPECTED_REP=$(docker service ls | grep -c "/[1-2] ")
NUM_EXPECTED_REP=$((NUM_EXPECTED_REP + 1))
NUM_RUNNING_REP=$(docker service ls | grep -c "[1-2]/")
BROWSER_RUNNING=$(docker service ls | grep browser | awk {'print $4'} | grep -c '0/0')
if [ $BROWSER_RUNNING -eq 0 ]; then
    NUM_RUNNING_REP=$((NUM_RUNNING_REP + 1))
fi

CONTAINER_TAG="$(grep -r 'shield-autoupdate' $ES_VER_FILE | cut -d' ' -f2)"
if [ "$CONTAINER_TAG" = "" ]; then
   CONTAINER_TAG="shield-autoupdate:180328-06.56-1731"
fi

docker run --rm  -it \
       -v /var/run/docker.sock:/var/run/docker.sock \
       -v $(which docker):/usr/bin/docker \
       -v "$ES_PATH:$ES_PATH" \
       "securebrowsing/$CONTAINER_TAG" status "${@}"

exit 0
