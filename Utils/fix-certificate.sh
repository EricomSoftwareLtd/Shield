#!/bin/bash
############################################
#####   Ericom Shield Fix Certificate  #####
#######################################BH###

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

docker service scale shield_shield-admin=0
CONSUL_ID=$(docker ps | grep  shield-config | awk {' print $1 '} | head -n 1)
docker exec -it $CONSUL_ID  bash -c 'consul kv delete -recurse settings/certificate'
docker exec -it $CONSUL_ID  bash -c 'consul kv delete -recurse settings/certificate-tmp'
docker service scale shield_shield-admin=1
