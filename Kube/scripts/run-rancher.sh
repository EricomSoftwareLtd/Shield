#!/bin/bash -e
############################################
#####   Ericom Shield Running Rancher  #####
#######################################BH###
APP="Rancher"
APP_VERSION="v2.2.8"
# This release comes with the latest Kubernetes versions, i.e. v1.13.10, v1.14.6, v1.15.3,
# for Rancher launched Kubernetes clusters to address the Kubernetes security announcement.
# Rancher recommends upgrading all Kubernetes clusters to these Kubernetes versions.
ES_PATH="$HOME/ericomshield"
ES_RANCHER_STORE="$ES_PATH/rancher-store"

mkdir -p "$ES_RANCHER_STORE"

echo "Running Rancher ($APP_VERSION)"
docker run -d --restart=unless-stopped \
    -p 8443:443 \
    -v $ES_RANCHER_STORE:/var/lib/rancher \
    rancher/rancher:$APP_VERSION

echo " Rancher UI is available on port 8443"
