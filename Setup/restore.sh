#!/bin/bash


#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo "Usage: $0 [filename]"
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

all=($(docker ps | grep consul-server | awk {'print $1'}))

if [ ${#all[@]} -eq 0 ]; then
    echo "No consul-server containers run on this node"
    exit
fi

docker exec -t ${all[0]} python /scripts/manual_restore.py "$1"
