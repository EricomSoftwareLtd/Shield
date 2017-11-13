#!/bin/bash
############################################
#####   Ericom Shield Installer        #####
#######################################LO###

export DOCKER_TAG=171106-09.02

docker run --rm -it \
    -v /var/run/docker.sock:/var/run/docker.sock \
	-v $(which docker):/usr/bin/docker \
	--network host \
    securebrowsing/node-installer:$DOCKER_TAG ./setup-node.sh "${@}"