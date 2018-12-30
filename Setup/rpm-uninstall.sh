#!/bin/bash
############################################
#####   Ericom Shield Uninstaller      #####
#######################################BH###

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

echo "***********       Removing EricomShield images"

docker kill $(docker ps -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)

echo "***********       Removing EricomShield Stack"
echo "***********       "
docker stack rm $STACK_NAME
docker swarm leave -f

if [ "$1" == "-a" ]; then
    docker system prune -f -a --volumes
else
    docker system prune -f
fi

rpm -e ericom_shield

echo "Done!"
