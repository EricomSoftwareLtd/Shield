#!/bin/bash
############################################
#####   Ericom Shield: Install Shield  #####
#######################################BH###
echo "File is deprecated"
echo " Executing: ./install-shield-from-container.sh"

#Check if we are root
if ((EUID != 0)); then
    # sudo su
    usage
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

rm ./install-shield-fom-container.sh
wget https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Dev/Kube/scripts/install-shield-from-container.sh
chmod +x install-shield-from-container.sh
bash ./install-shield-from-container.sh $@

if [ $? != 0 ]; then
   echo
   echo "*************** Installation Failed, Exiting!"
   echo
   echo "Make sure you are using the right password!"
   exit 1
fi

exit
