#!/bin/bash -e
############################################
#####   Ericom Shield Running Rancher  #####
#######################################BH###
APP="Rancher"
APP_VERSION="v2.2.6"

mkdir -p ~/rancher-store

echo "Running Rancher ($APP_VERSION)"
docker run -d --restart=unless-stopped \
    -p 8443:443 \
    -v ~/rancher-store:/var/lib/rancher \
    rancher/rancher:$APP_VERSION

echo " Rancher UI is available on port 8443"