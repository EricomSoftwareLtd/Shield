#!/bin/bash
############################################
#####   Ericom Shield Installer:Docker #####
#######################################BH###
APP="docker"
APP_BIN="/usr/bin/docker"
APP_VERSION="19.03.8"
ES_FORCE=false

function usage() {
    echo " Usage: $0 [-f|--force]"
}

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -f | --force)
        ES_FORCE=true
        ;;
    -h | --help)
    #*)
        usage
        exit
        ;;
    esac
    shift
done

if [ ! -x "$APP_BIN" ] || [ "$($APP_BIN version | grep -c $APP_VERSION)" -le 0 ] || [ "$ES_FORCE" = true ]; then
    echo "Installing $APP ..."
    DOCKER_SCRIPT_URL="https://releases.rancher.com/install-docker/$APP_VERSION.sh"
    curl -LJ --progress-bar $DOCKER_SCRIPT_URL | sh
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -aG docker "$USER" 
    echo "Done!"
else
    echo "$APP is already installed"
fi
