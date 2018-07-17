#!/bin/bash
############################################
#####   Ericom Shield Stop             #####
#######################################BH###

ES_PATH=/usr/local/ericomshield
LOGFILE="$ES_PATH/ericomshield.log"
SHIELD_CORE_STACK_NAME='shield-core'
SHIELD_BROWSERS_FARM_STACK_NAME='shield-browsers-farm'

echo "***********       Stopping Ericom Shield "
echo "***********       "
if [ -z "$(docker info | grep -i 'swarm: active')" ]; then
    echo "Docker swarm is not active, '$SHIELD_CORE_STACK_NAME' stack is not running."
    exit 0
fi
echo "$(date): Stopping Ericom Shield" >>"$LOGFILE"
docker stack rm $SHIELD_CORE_STACK_NAME
echo "Waiting for $SHIELD_CORE_STACK_NAME to stop..."
#Always waiting 10+30 seconds to make sure everything is cleaned
sleep 10
limit=30
until [ -z "$(docker service ls --filter label=com.docker.stack.namespace=$SHIELD_CORE_STACK_NAME -q)" ] || [ "$limit" -lt 1 ]; do
    echo $limit
    sleep 1
    limit=$((limit - 1))
done
echo "done"

docker stack rm $SHIELD_BROWSERS_FARM_STACK_NAME
echo "Waiting for $SHIELD_BROWSERS_FARM_STACK_NAME to stop..."
#Always waiting 10+30 seconds to make sure everything is cleaned
sleep 10
limit=30
until [ -z "$(docker service ls --filter label=com.docker.stack.namespace=$SHIELD_BROWSERS_FARM_STACK_NAME -q)" ] || [ "$limit" -lt 1 ]; do
    echo $limit
    sleep 1
    limit=$((limit - 1))
done
echo "done"
