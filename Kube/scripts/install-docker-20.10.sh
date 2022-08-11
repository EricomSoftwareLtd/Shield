#!/bin/bash
############################################
#####   Ericom Shield Installer:Docker #####
#######################################BH###
APP="docker"
APP_BIN="/usr/bin/docker"
APP_VERSION="20.01"
#CONTAINERD_VERSION="1.2"
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
    sudo apt-get update || exit $?
    sudo apt-get -y install software-properties-common || exit $?
    sudo add-apt-repository universe || exit $?
    sudo apt-get update || exit $?
    sudo apt-mark unhold docker.io
    sudo apt-get install -y "docker.io=${APP_VERSION}*" "containerd=${CONTAINERD_VERSION}*" || exit $?
    sudo apt-mark hold docker.io
    sudo systemctl enable --now docker || exit $?
    sudo usermod -aG docker "$USER"
    echo "Done!"
else
    echo "$APP is already installed"
fi
