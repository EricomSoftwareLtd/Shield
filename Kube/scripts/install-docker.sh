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

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    usage
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

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
    sh /tmp/get-docker.sh
    rm -f /tmp/get-docker.sh
    echo "Done!"
else
    echo "$APP is already installed"
fi
