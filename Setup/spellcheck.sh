#!/usr/bin/env bash


ES_PATH=/usr/local/ericomshield

if ((EUID != 0)); then
    #    sudo su
    echo "Usage: $0 [filename]"
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi


if [[ "$1" != "--enable" && "$1" != "--disable" ]]; then
    echo "--------------------- Usage -----------------------------"
    echo "Usage: $0 --enable/--disable on/off parameter is required"
    echo ""
    exit 1
fi

all=($(docker ps | grep consul-server | awk {'print $1'}))

if [ ${#all[@]} -eq 0 ]; then
    echo "No consul-server containers run on this node"
    exit
fi


docker exec -t ${all[0]} python /scripts/spellcheck_control.py $1
