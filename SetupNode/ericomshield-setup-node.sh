#!/bin/bash
############################################
#####   Ericom Shield Installer        #####
#######################################LO###

export DOCKER_TAG=1.0

docker run --rm -it \
    -v /var/run/docker.sock:/var/run/docker.sock \
	-v $(which docker):/usr/bin/docker \
	--network host \
    securebrowsing/node-installer:$DOCKER_TAG ./setup-node.sh "${@}"