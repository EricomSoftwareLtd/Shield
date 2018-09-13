#!/bin/bash
#################################################
#####   Ericom Shield Registry Cache        #####
############################################BH###

ES_PATH="/usr/local/ericomshield"
ES_REG_PATH="$ES_PATH/registry"
ES_REG_YML_REPO="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Dev/Utils/shield-registry-config.yml"
ES_REG_YML="$ES_REG_PATH/shield-registry-config.yml"
ES_REG_DATA="$ES_REG_PATH/data"

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo "Usage: $0"
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

# Create the Ericom empty dir if necessary
if [ ! -d $ES_PATH ]; then
    mkdir -p $ES_PATH
    chmod 0755 $ES_PATH
fi

# Create the Registry dir if necessary
if [ ! -d $ES_REG_PATH ]; then
    mkdir -p $ES_REG_PATH
    chmod 0755 $ES_REG_PATH
fi

cd "$ES_REG_PATH" || exit

# Create the Registry dir if necessary
if [ ! -d $ES_REG_DATA ]; then
    mkdir -p $ES_REG_DATA
    chmod 0755 $ES_REG_DATA
fi

echo "Getting $ES_PRE_CHECK_FILE"
wget -q "$ES_REG_YML_REPO"
    
echo $ES_REG_YML
docker run -d --restart yes -p 5000:5000 \
 -v "$ES_REG_YML:/etc/docker/registry/config.yml" \
 -v "$ES_REG_DATA:/var/lib/registry" \
 --name registry registry:2
