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

function usage(){
       echo " Usage: $0 [backup-filename]"
       echo " Restore Shield Configuration from a backup file"
       echo " Restore latest backup if no filename is specified"
       echo " Backups files are located in $ES_PATH/backup/ folder"
}

case "$1" in
    -h | --help)
       usage
       exit 0
    ;;
    *)
       FILE_NAME="$1"

       if [ ! -z $FILE_NAME ]; then
          if [ -f "$FILE_NAME" ]; then
             cp "$FILE_NAME" "$ES_PATH/backup/"
           else
             echo "File $FILE_NAME not found"
             echo
             exit 1
          fi
       fi
    ;;
esac

all=($(docker ps | grep consul-server | awk {'print $1'}))

if [ ${#all[@]} -eq 0 ]; then
    echo " Restore can be done only when Shield is running"
    echo " Please run start.sh first"
    exit
fi

docker exec -t ${all[0]} python /scripts/manual_restore.py $FILE_NAME
