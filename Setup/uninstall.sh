#!/bin/bash
############################################
#####   Ericom Shield Uninstaller      #####
#######################################BH###
ES_PATH=/usr/local/ericomshield
LOGFILE="$ES_PATH/ericomshield.log"
STACK_NAME=shield

function show_usage() {
    echo "Uninstall Ericom Shield"
    echo "Usage: $0 [-h] [-a]"
    echo "$0 -h : print usage"
    echo "$0 -a : uninstall all and clean all images and volumes"
    exit
}

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo " Please run it as Root"
    echo "sudo $0 $@"
    show_usage
    exit
fi

if [ ! -z $1 ] && [ "$1" != "-a" ]; then
    show_usage
fi

ES_PATH="/usr/local/ericomshield"
LOGFILE="$ES_PATH/ericomshield.log"
STACK_NAME=shield
cd $ES_PATH

echo "***********       Uninstalling Ericom Shield ...."
echo "$(date): Uninstalling Ericom Shield" >>"$LOGFILE"
mv "$LOGFILE" ..

systemctl stop ericomshield-updater

echo "***********       Removing EricomShield images"

docker kill $(docker ps -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)

echo "***********       Removing EricomShield Services"
systemctl --global disable ericomshield-updater.service
systemctl daemon-reload

echo "***********       Removing EricomShield Stack"
echo "***********       "
docker stack rm $STACK_NAME
docker swarm leave -f

if [ "$1" == "-a" ]; then
    rm -rf $ES_PATH
    docker system prune -f -a --volumes
else
    docker system prune -f
    rm -f $ES_PATH/*
fi
echo "Done!"
