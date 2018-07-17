#!/bin/bash
############################################
#####   Ericom Shield Installer        #####
#######################################BH###

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo "Usage:" $0
    echo " Please run it as Root"
    echo "sudo" $0
    exit
fi
ES_PATH="/usr/local/ericomshield"
LOGFILE="$ES_PATH/ericomshield.log"
SHIELD_CORE_STACK_NAME='shield-core'
SHIELD_BROWSERS_FARM_STACK_NAME='shield-browsers-farm'
cd $ES_PATH

echo "***********       Uninstalling Ericom Shield ...."
echo "$(date): Uninstalling Ericom Shield" >>"$LOGFILE"
mv "$LOGFILE" ..

systemctl stop ericomshield-updater

echo "***********       Removing EricomShield Stack"
echo "***********       "
docker stack rm $SHIELD_CORE_STACK_NAME
docker stack rm $SHIELD_BROWSERS_FARM_STACK_NAME

echo "***********       Removing EricomShield images"

docker kill $(docker ps -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)

echo "***********       Removing EricomShield Services"
systemctl --global disable ericomshield-updater.service
systemctl daemon-reload

echo "***********       Leaving Swarm ..."
echo "***********       "
docker swarm leave -f

if [ "$1" == "-a" ]; then
    rm -rf $ES_PATH
    docker system prune -f -a --volumes
else
    docker system prune -f
    rm -f $ES_PATH/*
fi
echo "Done!"
