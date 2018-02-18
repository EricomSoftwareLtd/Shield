#!/bin/bash
############################################
#####   Ericom Shield ShowVersion      #####
#######################################BH###

ES_PATH=/usr/local/ericomshield
ES_VER_FILE="$ES_PATH/shield-version.txt"

function showversion() {
    echo "Ericom Shield Version:"
    while read -r ver; do
        if [ "${ver:0:1}" == '#' ]; then
            echo "$ver"
        else
            echo "$ver" | awk '{print $2}'
        fi
    done <"$ES_VER_FILE"
}

docker version

echo "********************************************************"

showversion
