#!/bin/bash
############################################
#####   Ericom Shield PrepareNode      #####
#######################################BH###

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo "Usage: $0"
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

rm ./prepare-node.sh
wget https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/master/Setup/prepare-node.sh
chmod +x prepare-node.sh
bash ./prepare-node.sh $@
