#!/bin/bash -e

docker run -d --restart=unless-stopped \
    -p 80:80 -p 443:443 \
    -v /home/rancher:/var/lib/rancher \
    rancher/rancher:latest
