#!/bin/bash

#Check if we are root
ES_PATH=/usr/local/ericomshield

if ((EUID != 0)); then
    #    sudo su
    echo "Usage: $0 [filename]"
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

if [ -n "$1" ]; then
    FILE_NAME="$1"

    if [ -f "$FILE_NAME" ]; then
        cp "$FILE_NAME" "$ES_PATH/backup/"
    else
        echo "File $FILE_NAME not found"
        exit 1
    fi
fi

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -h | --help)
        echo "Usage: $0 [filename]"
        exit 0
        ;;
    esac
    shift
done

all=($(docker ps | grep consul-server | awk {'print $1'}))

if [ ${#all[@]} -eq 0 ]; then
    echo "No consul-server containers run on this node"
    exit
fi

docker exec -t ${all[0]} python /scripts/manual_restore.py $FILE_NAME
