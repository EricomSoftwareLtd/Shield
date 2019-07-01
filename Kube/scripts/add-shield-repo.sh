#!/bin/bash
################################################
#####   Ericom Shield Installer:add_repo   #####
###########################################BH###

function usage() {
    echo " Usage: $0 <-d|--dev> <-s|--staging> -p <PASSWORD> "
}

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    usage
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

SHIELD_REPO="https://helmrepo.shield-service.net/staging"

PASSWORD=""

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -p | --password)
       shift
       PASSWORD=$1
       ;;
    -d | --dev | --Dev) # Dev Channel (master branch for now)
        SHIELD_REPO="http://helmrepo.shield-service.net:8080/dev"
        ;;
    -s | --staging | --Staging) # Dev Channel (Staging Branch)
        SHIELD_REPO="http://helmrepo.shield-service.net:8080/staging"
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
