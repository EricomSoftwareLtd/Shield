#!/bin/bash
############################################
#####   Ericom Shield ShowVersion      #####
#######################################BH###

ES_PATH=/usr/local/ericomshield
ES_VERSION="$ES_PATH/.version"

docker version

echo "********************************************************"

cat $ES_VERSION
