#!/bin/bash


docker run --rm -it \
    -v /var/run/docker.sock:/var/run/docker.sock \
	-v $(which docker):/usr/bin/docker \
	--network host \
    securebrowsing/node-installer:1.0 ./setup-node.sh "${@}"