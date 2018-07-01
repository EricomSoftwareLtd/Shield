#!/bin/bash
#################################################
#####   Ericom Shield Registry Cache        #####
############################################BH###

ES_PATH="/usr/local/ericomshield"
ES_REG_PATH="$ES_PATH/registry"
ES_REG_YML="$ES_REG_PATH/config.yml"
ES_REG_DATA="$ES_REG_PATH/data"

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo "Usage: $0"
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

# Create the Registry dir if necessary
if [ ! -d $ES_REG_PATH ]; then
    mkdir -p $ES_REG_PATH
    chmod 0755 $ES_REG_PATH
fi
# Create the Registry dir if necessary
if [ ! -d $ES_REG_DATA ]; then
    mkdir -p $ES_REG_DATA
    chmod 0755 $ES_REG_DATA
fi

echo $ES_REG_YML
docker run --rm -p 5000:5000 \
 -v "$ES_REG_YML:/etc/docker/registry/config.yml" \
 -v "$ES_REG_DATA:/var/lib/registry" \
 --name registry registry:2
