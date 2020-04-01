#!/bin/bash -e
############################################
#####   Ericom Shield Running Rancher  #####
#######################################BH###
APP="Rancher"
APP_VERSION="v2.3.6"
# This release comes with the latest Kubernetes versions, i.e. v1.13.10, v1.14.6, v1.15.3,
# for Rancher launched Kubernetes clusters to address the Kubernetes security announcement.
# Rancher recommends upgrading all Kubernetes clusters to these Kubernetes versions.
ES_PATH="$HOME/ericomshield"
ES_RANCHER_STORE="$ES_PATH/rancher-store"

if ! [ -d "$ES_RANCHER_STORE" ]; then
    mkdir -p "$ES_RANCHER_STORE"
fi

if ! ls -1qA "$ES_RANCHER_STORE" | grep -q .; then
    docker run --rm -it \
        -v $ES_RANCHER_STORE:/var-lib-rancher \
        --entrypoint /bin/sh \
        rancher/rancher:$APP_VERSION \
        -c "cp -rp /var/lib/rancher/. /var-lib-rancher/"
fi

if [ ! -z "$http_proxy" ] && [ -z "$HTTP_PROXY" ]; then
    HTTP_PROXY="$http_proxy"
fi
if [ ! -z "$HTTP_PROXY" ]; then
    RANCHER_PROXY_VARS="-e HTTP_PROXY=${HTTP_PROXY} -e HTTPS_PROXY=${HTTPS_PROXY} -e NO_PROXY=localhost,127.0.0.1,0.0.0.0,${NO_PROXY}"
fi

if [ ! -z "$ES_OFFLINE_REGISTRY" ]; then
    RANCHER_REGISTRY_VARS="-e CATTLE_SYSTEM_DEFAULT_REGISTRY=${ES_OFFLINE_REGISTRY}"
fi

if [ $(docker ps | grep -c rancher/rancher:) -lt 1 ]; then
    echo
    echo "Running Rancher ($APP_VERSION)"
    docker run -d --restart=unless-stopped \
        -p 8443:443 \
        -e CATTLE_SYSTEM_CATALOG=bundled ${RANCHER_PROXY_VARS} ${RANCHER_REGISTRY_VARS} \
        -v $ES_RANCHER_STORE:/var/lib/rancher \
        rancher/rancher:$APP_VERSION
else
    echo "Rancher is already running"
fi

function get_outgoing_ip() {
    local ADDR=$(echo $1 | grep -oP '.*://\K([0-9\.]*)') #'
    if [ -z $ADDR ]; then
        ADDR=$1
    fi
    ip route get $ADDR | awk -F"src " 'NR==1{split($2,a," ");print a[1]}'
}

function get_my_ip() {
    local MY_IP="$(get_outgoing_ip 8.8.8.8)"
    if [ -z $MY_IP ]; then
        MY_IP="$(get_outgoing_ip $HTTP_PROXY)"
    fi
    if [ -z $MY_IP ]; then
        MY_IP="$(get_outgoing_ip $http_proxy)"
    fi
    echo $MY_IP
}

MY_IP="$(get_my_ip)"
RANCHER_URL="https://$MY_IP:8443"
EXTERNAL_IP="$(curl -s http://whatismyip.akamai.com/ && echo)"

echo " Rancher UI is available on port 8443"
echo $RANCHER_URL
