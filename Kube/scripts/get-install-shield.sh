#!/bin/bash
############################################
#####   Ericom Shield Install          #####
#######################################BH###

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

rm ./shield-support.sh
wget https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/master/Shield/Kube/scripts/install-shield.sh
chmod +x install-shield.sh
bash ./install-shield.sh $@
