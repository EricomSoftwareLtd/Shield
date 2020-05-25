#!/bin/bash
############################################
#####   Ericom Shield: Install Shield  #####
#######################################BH###

FILE_SERVER="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Dev/Kube/scripts"
#Check if we are root
if ((EUID != 0)); then
    # sudo su
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

args="$@"

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    --registry) # Specify Offline Registry address and port
        shift
        export ES_OFFLINE_REGISTRY="$1"
        FILE_SERVER=$(echo $ES_OFFLINE_REGISTRY | cut -d ":" -f1 )
        FILE_SERVER="http://$FILE_SERVER/ericomshield"
        ;;
    esac
    shift
done

echo " Executing: ./install-shield-from-container.sh"

wget "$FILE_SERVER/install-shield-from-container.sh" -O install-shield-from-container.sh
chmod +x install-shield-from-container.sh
bash ./install-shield-from-container.sh $args

if [ $? != 0 ]; then
   echo
   echo "*************** Installation Failed, Exiting!"
   echo
   echo "Make sure you are using the right password!"
   exit 1
fi

exit
