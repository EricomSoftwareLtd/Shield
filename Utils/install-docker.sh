#!/bin/bash -ex
############################################
#####   Ericom Shield Docker Installer #####
####################################AN#BH###

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo "Usage: $0"
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

if [ ! -f ./docker-debs.tgz ]; then
   echo "docker-debs.tgz file not found, exiting!"
fi

tar xvfz docker-debs.tgz
dpkg -i docker_debs/*.deb
