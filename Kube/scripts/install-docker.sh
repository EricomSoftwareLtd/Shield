#!/bin/bash
############################################
#####   Ericom Shield Installer:Docker #####
#######################################BH###
APP="docker"
APP_BIN="/usr/bin/docker"
APP_VERSION="18.09"
ES_FORCE=false

function usage() {
    echo " Usage: $0 "
}

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -f | --force)
        ES_FORCE=true
        ;;
    #    -h | --help)
    *)
        usage
        exit
        ;;
    esac
    shift
done

if [ ! -x $APP_BIN ] || [ "$($APP_BIN version | grep -c $APP_VERSION)" -le 1 ] || [ $ES_FORCE == true ]; then
    echo "Installing $APP ..."
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    sudo sh /tmp/get-docker.sh
    rm -f /tmp/get-docker.sh
    sudo systemctl enable docker
    sudo systemctl start docker
    echo "Done!"
else
    echo "$APP is already installed"
fi
