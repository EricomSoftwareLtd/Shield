#!/bin/bash
############################################
#####   Ericom Shield Installer        #####
#######################################LO###

export DOCKER_TAG=171123-17.00

docker run --rm -it \
    -v /var/run/docker.sock:/var/run/docker.sock \
	-v $(which docker):/usr/bin/docker \
	-v $(pwd):/certificate \
	--network host \
    securebrowsing/node-installer:$DOCKER_TAG ./setup-node.sh "${@}"