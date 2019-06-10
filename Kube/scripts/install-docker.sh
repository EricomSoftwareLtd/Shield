#!/bin/bash
############################################
#####   Ericom Shield Installer:Docker #####
#######################################BH###
APP="docker"

function usage() {
    echo " Usage: $0 "
}

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    usage
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

if [ ! -x /usr/bin/docker ]; then
   echo "Installing $APP ..."
   curl -fsSL https://get.docker.com -o get-docker.sh
   sh get-docker.sh
   echo "Done!"
 else
  echo "$APP is already installed"
fi
