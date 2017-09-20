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
STACK_NAME=shield

cd $ES_PATH

systemctl stop ericomshield
systemctl stop ericomshield-updater

docker kill $(docker ps -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)

echo "Uninstalling Ericom Shield"
echo "$(date): Uninstalling Ericom Shield" >>"$LOGFILE"
mv "$LOGFILE" ..
systemctl --global disable ericomshield-updater.service
systemctl --global disable ericomshield.service
systemctl daemon-reload

rm /etc/init.d/ericomshield

echo "***********       Removing EricomShield "
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
