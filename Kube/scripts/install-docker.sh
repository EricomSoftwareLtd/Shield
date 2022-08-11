#!/bin/bash
############################################
#####   Ericom Shield Installer:Docker #####
#######################################BH###
APP="docker"
APP_BIN="/usr/bin/docker"
APP_VERSION="20.10"
DEB_APP_VERSION="5:$APP_VERSION"
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
    if [ -z "$(apt-cache search --names-only '^docker-ce$')" ]; then
        DOCKER_SCRIPT_URL="https://releases.rancher.com/install-docker/$APP_VERSION.sh"
        curl -LJ --progress-bar $DOCKER_SCRIPT_URL | sudo sh
    else
        sudo apt-get update || exit $?
        sudo apt-get -y install software-properties-common || exit $?
        sudo add-apt-repository universe || exit $?
        sudo apt-get update || exit $?
        sudo apt-get purge docker.io containerd || exit $?
        sudo apt-mark unhold docker-ce
        sudo apt-get install --allow-downgrades -y "docker-ce=${DEB_APP_VERSION}*" "docker-ce-cli=${DEB_APP_VERSION}*" "containerd.io" || exit $?
    fi
    sudo apt-mark hold docker-ce
    sudo systemctl enable --now docker || exit $?
    sudo usermod -aG docker "$USER"
    echo "Done!"
else
    echo "$APP is already installed"
fi
