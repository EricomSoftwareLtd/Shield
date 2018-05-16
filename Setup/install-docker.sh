#!/bin/bash
############################################
#####   Ericom Shield Docker Installer  ####
#######################################BH###

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo "Usage: $0 [-force] [-autoupdate] [-dev] [-staging] [-quickeval] [-usage]"
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi
ES_PATH="/usr/local/ericomshield"
LOGFILE="$ES_PATH/ericomshield.log"
DOCKER_DEFAULT_VERSION="18.03.0"
DOCKER_VERSION=""
ES_DEV_FILE="$ES_PATH/.esdev"
ES_STAGING_FILE="$ES_PATH/.esstaging"
ES_REPO_FILE="$ES_PATH/ericomshield-repo.sh"
ES_VER_FILE_NEW="$ES_PATH/shield-version-new.txt"
NOT_FOUND_STR="404: Not Found"
BRANCH="master"

ES_DEV=false
ES_STAGING=false

function log_message() {
    local PREV_RET_CODE=$?
    echo "$@"
    echo "$(LC_ALL=C date): $@" | LC_ALL=C perl -ne 's/\x1b[[()=][;?0-9]*[0-9A-Za-z]?//g;s/\r//g;s/\007//g;print' >>"$LOGFILE"
    if ((PREV_RET_CODE != 0)); then
        return 1
    fi
    return 0
}

cd "$ES_PATH" || exit

if [ -f "$ES_DEV_FILE" ]; then
    ES_DEV=true
fi

if [ -f "$ES_STAGING_FILE" ]; then
    ES_STAGING=true
fi

function install_docker() {

    if [ -f  "$ES_VER_FILE_NEW" ]; then
       DOCKER_VERSION="$(grep -r 'docker-version' "$ES_VER_FILE_NEW" | cut -d' ' -f2)"
    fi
    if [ "$DOCKER_VERSION" = "" ]; then
       DOCKER_VERSION="$DOCKER_DEFAULT_VERSION"
       echo "Using default Docker version: $DOCKER_VERSION"
    fi

    if [ "$(sudo docker version | grep -c $DOCKER_VERSION)" -le 1 ]; then
        log_message "***************     Installing docker-engine: $DOCKER_VERSION"
        apt-get --assume-yes -y install apt-transport-https software-properties-common python-software-properties

        #Docker Installation of a specific Version
        curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        echo -n "apt-get -qq update ..."
        apt-get -qq update
        echo "done"
        sudo apt-cache policy docker-ce
        echo "Installing Docker: docker-ce=$DOCKER_VERSION~ce-0~ubuntu"
        sudo apt-get -y --assume-yes --allow-downgrades install docker-ce=$DOCKER_VERSION~ce-0~ubuntu
    else
        echo " ******* docker-engine $DOCKER_VERSION is already installed"
    fi
    if [ "$(sudo docker version | grep -c $DOCKER_VERSION)" -le 1 ]; then
        log_message "Failed to Install/Update Docker, Exiting!"
        exit 1
    fi
}

function get_shield_version_file() {
    echo "Getting $ES_REPO_FILE"
    ES_repo_setup="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/ericomshield-repo.sh"
    curl -s -S -o "shield_repo_tmp.sh" $ES_repo_setup
    if [ ! -f shield_repo_tmp.sh ] || [ $(grep -c "$NOT_FOUND_STR" shield_repo_tmp.sh) -ge 1 ]; then
        log_message "Cannot Retrieve version file for version: $BRANCH"
        exit 1
    fi

    mv shield_repo_tmp.sh "$ES_REPO_FILE"

    #include file with files repository
    source $ES_REPO_FILE

    echo "Getting shield version files"
    if [ "$ES_DEV" == true ]; then
        echo "Getting $ES_repo_dev_ver (dev)"
        curl -s -S -o "$ES_VER_FILE_NEW" "$ES_repo_dev_ver"
    elif [ "$ES_STAGING" == true ]; then
        echo "Getting $ES_repo_staging_ver (staging)"
        curl -s -S -o "$ES_VER_FILE_NEW" "$ES_repo_staging_ver"
    else
        echo "Getting $ES_repo_ver (prod)"
        curl -s -S -o "$ES_VER_FILE_NEW" "$ES_repo_ver"
    fi
}

get_shield_version_file

install_docker
