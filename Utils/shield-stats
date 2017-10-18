#!/bin/bash
#####   Ericom Shield Run              #####
#######################################BH###

if (( $EUID != 0 )); then
#    sudo su
        echo " Please run it as Root"
        echo "sudo" $0
        exit
fi


HOST=`hostname`
LOGFILE="./ericomshield-load.log"

echo "        *****************************************************" >> "$LOGFILE"
echo "$(date):****************** Ericom Shield System Stats ($HOST)" >> "$LOGFILE"


/usr/local/ericomshield/status.sh -a >> "$LOGFILE"
echo " " >> "$LOGFILE"

docker system df
docker system df  >> "$LOGFILE"
echo " " >> "$LOGFILE"

docker stats -a --no-stream $(docker ps --format={{.Names}})
docker stats -a --no-stream >> "$LOGFILE" $(docker ps --format={{.Names}})

echo "        *****************************************************" >> "$LOGFILE"
