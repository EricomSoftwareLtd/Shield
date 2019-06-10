#!/bin/bash
############################################
#####   Ericom Shield Rancher          #####
#######################################BH###


#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    usage
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  -v /home/rancher:/var/lib/rancher \
  rancher/rancher:latest
