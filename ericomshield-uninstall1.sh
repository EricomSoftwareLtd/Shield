#!/bin/bash
############################################
#####   Ericom Shield Installer        #####
#######################################BH###

#Check if we are root
if (( $EUID != 0 )); then
#    sudo su
        echo "Usage:" $0
        echo " Please run it as Root"
        echo "sudo" $0
        exit
fi
ES_PATH="/usr/local/ericomshield"
LOGFILE="$ES_PATH/ericomshield.log"
ES_SWARM_FILE="$ES_PATH/.esswarm"
STACK_NAME=shield

cd $ES_PATH

service ericomshield stop
docker-compose down

docker kill $(docker ps -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)

echo "Uninstalling Ericom Shield"
echo "$(date): Uninstalling Ericom Shield" >> "$LOGFILE"
mv "$LOGFILE" ..
systemctl --global disable ericomshield-updater.service
systemctl --global disable ericomshield.service
systemctl daemon-reload

rm /etc/init.d/ericomshield

echo "***********       Removing EricomShield (swarm) "
echo "***********       "
docker stack rm $STACK_NAME
docker swarm leave -f

docker system prune -f -a

rm -f $ES_PATH/*
rm -f $ES_PATH/.*


echo "Done!"
