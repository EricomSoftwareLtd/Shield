#!/bin/bash
################################################
#####   Ericom Shield Installer:add_repo   #####
###########################################BH###

function usage() {
    echo " Usage: $0 <-d|--dev> <-s|--staging> -p <PASSWORD> "
}

SHIELD_REPO_URL="https://helmrepo.shield-service.net"
SHIELD_REPO="$SHIELD_REPO_URL/rel1907"

PASSWORD=""

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -p | --password)
        shift
        PASSWORD=$1
        ;;
    -d | --dev | --Dev) # Dev Channel (master branch for now)
        SHIELD_REPO="$SHIELD_REPO_URL/dev"
        ;;
    -s | --staging | --Staging) # Dev Channel (Staging Branch)
        SHIELD_REPO="$SHIELD_REPO_URL/staging"
        ;;
    *)
        usage "$0"
        exit
        ;;
    esac
    shift
done

if [ "$PASSWORD" == "" ]; then
    echo " Error: Password is missing"
    usage
    exit
fi

helm repo add shield-repo --username=ericom --password=$PASSWORD $SHIELD_REPO
helm repo update

helm search shield
