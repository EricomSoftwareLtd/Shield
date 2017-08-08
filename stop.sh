#!/bin/bash
############################################
#####   Ericom Shield Stop             #####
#######################################BH###

ES_PATH=/usr/local/ericomshield
STACK_NAME=shield

echo "***********       Stopping EricomShield "
echo "***********       "
docker stack rm $STACK_NAME
#   docker swarm leave -f
umount /tmp/containershm
