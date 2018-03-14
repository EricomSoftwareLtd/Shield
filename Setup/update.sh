#!/bin/bash


    docker run --rm -it \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v $(which docker):/usr/bin/docker \
        -v /usr/local/ericomshield:/usr/local/ericomshield \
        securebrowsing/shield-autoupdate:test "${@}"