#!/bin/bash
############################################
#####   Ericom Shield: Install Shield  #####
#######################################BH###

ES_OFFLINE="false"
FILE_SERVER="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/master/Kube/scripts"
REGISTRY_FILE_SERVER_PORT=85
ES_FORCE_INSTALL="false"

#Check if we are root
if ((EUID != 0)); then
    # sudo su
    echo " Please run it as Root"
    echo "sudo -E $0 $@"
    exit
fi

args="$@"

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    --registry) # Specify Offline Registry address and port
        shift
        export ES_OFFLINE_REGISTRY="$1"
        FILE_SERVER="$(echo $ES_OFFLINE_REGISTRY | cut -d ":" -f1 ):$REGISTRY_FILE_SERVER_PORT"
        FILE_SERVER="http://$FILE_SERVER/ericomshield"
        ;;
    -O | --Offline) # Offline Mode
        ES_OFFLINE="true"
        ;;
    -f | --force) # force installation
        ES_FORCE_INSTALL="true"
        ;;
    esac
    shift
done

if [ "$HOME" = "/root" ]; then
    echo "WARNING: you are installing Shield to the /root directory!"
    echo "Shield is supposed to be installed elsewhere (usually in /home/ericom)."
    echo "Probably you need to run sudo -E instead of sudo."
    if [ "$ES_FORCE_INSTALL" = "true" ]; then
        echo "--force has been specified, continuing anyway..."
    else
        echo "Exiting... Use -f or --force to override."
        exit 1
    fi
fi

if [ $ES_OFFLINE = "false" ]; then
   wget "$FILE_SERVER/install-shield-from-container.sh" --tries 3 -O install-shield-from-container-new.sh
   # An Error Occured Downloading the install script
   if [ $? != 0 ]; then
      rm -f install-shield-from-container-new.sh
      if [ -f install-shield-from-container.sh ]; then
         # File Cannot be downloaded but local file exists, assuming OFFLINE_MODE
         args="$args -O"
        else
         # Cannot Install Shield,  
         echo
         echo " Cannot Download $FILE_SERVER/install-shield-from-container.sh"
         echo " Make sure you are connected to the internet or the Offline Registry is available"
         echo
         echo "*************** Installation Failed, Exiting!"
         echo
      
         exit 1
    fi
   else
     mv  install-shield-from-container-new.sh install-shield-from-container.sh
   fi  
fi

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
