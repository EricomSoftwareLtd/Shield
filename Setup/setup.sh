#!/bin/bash
############################################
#####   Ericom Shield Installer        #####
#######################################BH###

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo "Usage: $0 [-force] [-autoupdate] [-dev] [-staging] [-quickeval] [-usage]"
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

rm ./ericomshield-setup.sh
wget https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/master/Setup/ericomshield-setup.sh
chmod +x ericomshield-setup.sh
bash ./ericomshield-setup.sh $@
