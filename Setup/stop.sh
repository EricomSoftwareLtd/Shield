#!/bin/bash
############################################
#####   Ericom Shield Stop             #####
#######################################BH###

ES_PATH=/usr/local/ericomshield
LOGFILE="$ES_PATH/ericomshield.log"
STACK_NAME=shield

if ((EUID != 0)); then
    #    sudo su
    echo "Usage: $0 [filename]"
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

echo "***********       Stopping Ericom Shield "
echo "***********       "
if [ -z "$(docker info | grep -i 'swarm: active')" ]; then
    echo "Ericom Shield is not running on this machine"
    exit 0
fi
echo "$(date): Stopping Ericom Shield" >>"$LOGFILE"
#   docker swarm leave -f
docker stack rm $STACK_NAME
echo "Waiting for $STACK_NAME to stop..."
#Always waiting 10-40 seconds to make sure everything is cleaned
sleep 10
limit=30
until [ -z "$(docker service ls --filter label=com.docker.stack.namespace=$STACK_NAME -q)" ] || [ "$limit" -lt 1 ]; do
    echo $limit
    sleep 1
    limit=$((limit - 1))
done
echo "done"
