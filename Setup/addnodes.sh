#!/bin/bash
############################################
#####   Ericom Shield AddNode          #####
#######################################LO###

ES_PATH=/usr/local/ericomshield
ES_VER_FILE="./shield-version.txt"
LOGFILE="$ES_PATH/ericomshield.log"

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
CONTAINER_TAG="$(grep -r 'node-installer' $ES_VER_FILE | cut -d' ' -f2)"

docker run --rm -it \
    -v /var/run/docker.sock:/var/run/docker.sock \
	-v $(which docker):/usr/bin/docker \
	-v /usr/local/ericomshield:/install \
	-v $(pwd):/certificate \
	--network host \
    securebrowsing/$CONTAINER_TAG ./setup-node.sh "${@}"
