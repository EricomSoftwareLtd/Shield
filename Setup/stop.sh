#!/bin/bash
############################################
#####   Ericom Shield Stop             #####
#######################################BH###

ES_PATH=/usr/local/ericomshield
STACK_NAME=shield

function exit_success() {
    echo "***********       "
    exit 0
}

echo "***********       Stopping EricomShield "
if [ -z "$(docker info | grep -i 'swarm: active')" ]; then
    echo "Docker swarm is not active, '$STACK_NAME' stack is not running."
    exit_success
fi
#   docker swarm leave -f
docker stack rm $STACK_NAME
echo "Waiting for $STACK_NAME to stop..."
sleep 5
limit=10
until [ -z "$(docker service ls --filter label=com.docker.stack.namespace=$STACK_NAME -q)" ] || [ "$limit" -lt 1 ]; do
    echo $limit
    sleep 1
    limit=$((limit - 1))
done
echo "done"
exit_success
