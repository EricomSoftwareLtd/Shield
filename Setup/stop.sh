#!/bin/bash
############################################
#####   Ericom Shield Stop             #####
#######################################BH###

ES_PATH=/usr/local/ericomshield
LOGFILE="$ES_PATH/ericomshield.log"
STACK_NAME=shield

echo "***********       Stopping Ericom Shield "
echo "***********       "
if [ -z "$(docker info | grep -i 'swarm: active')" ]; then
    echo "Docker swarm is not active, '$STACK_NAME' stack is not running."
    exit 0
fi
echo "$(date): Stopping Ericom Shield" >>"$LOGFILE"
#   docker swarm leave -f
docker stack rm $STACK_NAME
echo "Waiting for $STACK_NAME to stop..."
#Always waiting 30 seconds to make sure everything is cleaned
sleep 10
limit=30
until [ -z "$(docker service ls --filter label=com.docker.stack.namespace=$STACK_NAME -q)" ] || [ "$limit" -lt 1 ]; do
    echo $limit
    sleep 1
    limit=$((limit - 1))
done
echo "done"
