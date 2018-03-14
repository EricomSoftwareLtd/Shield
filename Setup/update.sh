#!/bin/bash

CONTAINER_NAME="$(grep -r 'shield-autoupdate' ./shield-version.txt | cut -d' ' -f2)"


docker run --rm -it \
   -v /var/run/docker.sock:/var/run/docker.sock \
   -v $(which docker):/usr/bin/docker \
   -v /usr/local/ericomshield:/usr/local/ericomshield \
    securebrowsing/$CONTAINER_NAME "${@}"