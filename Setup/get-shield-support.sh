#!/bin/bash
############################################
#####   Ericom Shield Support          #####
#######################################BH###

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

rm ./shield-support.sh
wget https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Dev/Utils/shield-support.sh
chmod +x shield-support.sh
bash ./shield-support.sh $@
