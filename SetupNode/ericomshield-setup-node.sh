#!/bin/bash
############################################
#####   Ericom Shield Installer        #####
#######################################LO###

ES_PATH=/usr/local/ericomshield

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi
cd $ES_PATH

echo "Running deploy-shield.sh:"

export DOCKER_TAG=180206-14.18

docker run --rm -it \
    -v /var/run/docker.sock:/var/run/docker.sock \
	-v $(which docker):/usr/bin/docker \
	-v /usr/local/ericomshield:/install \
	-v $(pwd):/certificate \
	--network host \
    securebrowsing/node-installer:$DOCKER_TAG ./setup-node.sh "${@}"
