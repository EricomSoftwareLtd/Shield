#!/bin/bash
################################################
#####   Ericom Shield Installer:add_repo   #####
###########################################BH###

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

echo
echo "This script will cleanup Rancher (and any other container running on this node"
echo "Abort the script with 'Ctrl c' if this is not what you want to do (5s)"
echo
sleep 5

docker rm -f $(docker ps -qa)
docker volume rm $(docker volume ls -q)
cleanupdirs="/var/lib/etcd /etc/kubernetes /etc/cni /opt/cni /var/lib/cni /var/run/calico /opt/rke"
for dir in $cleanupdirs; do
    echo "Removing $dir"
    rm -rf $dir
done
