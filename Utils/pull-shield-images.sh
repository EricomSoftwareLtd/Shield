#!/bin/bash
############################################
#####   Ericom Shield Pull Images      #####
#######################################BH###

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo "Usage: $0 "
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi
ES_PATH="/usr/local/ericomshield"
ES_VER_FILE_NEW="$ES_PATH/shield-version-new.txt"
DEV_BRANCH="Dev"
STAGING_BRANCH="Staging"
BRANCH="master"
DOCKER_USER="ericomshield1"
DOCKER_SECRET="Ericom98765$"
ES_repo_ver="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/shield-version.txt"

function docker_login() {
    if [ "$(docker info | grep -c Username)" -eq 0 ]; then
       echo "docker login" $DOCKER_USER $DOCKER_SECRET
       echo "$DOCKER_SECRET" | docker login --username=$DOCKER_USER --password-stdin
    fi

    if [ $? == 0 ]; then
       echo "Login Succeeded!"
     else
       echo "Cannot Login to docker, Exiting!"
       exit 1
    fi
}

function get_shield_version() {
    echo "Getting shield install files"

    if [ ! -f "$ES_VER_FILE_NEW" ]; then
        echo "Getting $ES_repo_ver"
        curl -s -S -o "$ES_VER_FILE_NEW" "$ES_repo_ver"
    fi
}

function pull_images() {
    LINE=0
    while read -r line; do
        if [ "${line:0:1}" == '#' ]; then
            echo "$line"
        else
            arr=($line)
            if [ $LINE -ge 3 ]; then
                echo "################## Pulling images  ######################"
                echo "pulling image: ${arr[1]} ($SHIELD_REGISTRY)"
                docker pull "securebrowsing/${arr[1]}"
            fi
        fi
        LINE=$((LINE + 1))
    done <"$ES_VER_FILE_NEW"
}

    docker_login
    get_shield_version
    echo "************ Pull shield images"
    pull_images
    echo "***********  Done!"
    rm "$ES_VER_FILE_NEW" 
    
