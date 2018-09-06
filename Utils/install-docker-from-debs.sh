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

#stop docker in case it's running
systemctl stop docker || true

#extract docker-debs directory
tar xvfz docker-debs.tgz

#install deb files
dpkg -R -i docker_debs || dpkg -R -i docker_debs

#remove docker_deb directory
rm -rf ./docker_debs
