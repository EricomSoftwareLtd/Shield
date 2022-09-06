#!/bin/bash
#################################################
#####   Ericom Shield Pre-Install-Check     #####
############################################BH###

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo "Usage: $0"
    echo " Please run it as Root"
    echo "sudo -E $0 $@"
    exit
fi

APP="docker"
APP_BIN="/usr/bin/docker"
LOGFILE="${LOGFILE:-./shield-pre-install-check.log}"
RESULTS="./results-pre-check.log"
UPLOAD_ACCEPTED_FILE="./.upload_accepted"
FAILED_STR="failed"
NOT_FOUND_STR="404: Not Found"
NOUPLOAD=""
DOCKER_USER="ericomshield1"
DOCKER_SECRET="Ericom98765$"
ES_PATH="/tmp/ericomshield"
CONTAINER_TAG_DEFAULT="shield-collector:220706-08.25-1009"

HW_PLATFORM="$(uname -m)"
if [ "$HW_PLATFORM" != "x86_64" ]; then
    log_message "Current hardware platform is $HW_PLATFORM. Shield can be installed on x86_64 only. Exiting..."
    exit 1
fi

if ! declare -f log_message >/dev/null; then
    function log_message() {
        local PREV_RET_CODE=$?
        echo "$@"
        echo "$(LC_ALL=C date): $@" | LC_ALL=C perl -ne 's/\x1b[[()=][;?0-9]*[0-9A-Za-z]?//g;s/\r//g;s/\007//g;print' >>"$LOGFILE"
        if ((PREV_RET_CODE != 0)); then
            return 1
        fi
        return 0
    }
fi

if ! declare -f install_docker >/dev/null; then
    function install_docker() {

        if [ ! -x "$APP_BIN" ]; then
            ./install-docker.sh
        else
            echo " ******* docker is already installed"
        fi
        if [ ! -x "$APP_BIN" ]; then
            log_message "Failed to Install/Update Docker, exiting"
            exit -1
        fi
    }
fi

if ! declare -f docker_login >/dev/null; then
    function docker_login() {
        if [ "$(docker info | grep -c Username)" -eq 0 ]; then
            #Login and enter the credentials you received separately when prompt
            echo "docker login" $DOCKER_USER $DOCKER_SECRET
            echo "$DOCKER_SECRET" | docker login --username=$DOCKER_USER --password-stdin
            if [ $? == 0 ]; then
                echo "Login Succeeded!"
            else
                log_message "Cannot Login to docker, exiting"
                exit -1
            fi
        fi
    }
fi

function perform_env_test() {
    local ERR=0

    log_message "Running pre-install-check ..."

    if [ ! -f "$UPLOAD_ACCEPTED_FILE" ]; then
        if read -t 20 -p "Do you agree to send the pre-check results anonymously to Ericom (yes/no)? " choice; then
            case "$choice" in
            "n" | "no" | "NO" | "No")
                NOUPLOAD="noUpload"
                ;;
            "y" | "yes" | "YES" | "Yes")
                NOUPLOAD=""
                echo "yes"
                log_message "Upload results has been accepted"
                date -Iminutes >"$UPLOAD_ACCEPTED_FILE"
                ;;
            *) ;;
            esac
        else
            #If read fails consider that the user chose "no"
            NOUPLOAD="noUpload"
            echo "no"
        fi
    fi

    docker_login

    log_message "Running: $CONTAINER_TAG"
    docker run --privileged -it \
        --volume "/var/run/docker.sock:/var/run/docker.sock" \
        --volume "/dev:/hostdev" --volume "/proc:/hostproc" \
        --volume "/:/hostroot" \
        -e "http_proxy=$http_proxy" \
        -e "https_proxy=$https_proxy" \
        -e "ftp_proxy=$ftp_proxy" \
        -e "rsync_proxy=$rsync_proxy" \
        -e "HTTP_PROXY=$HTTP_PROXY" \
        -e "HTTPS_PROXY=$HTTPS_PROXY" \
        -e "FTP_PROXY=$FTP_PROXY" \
        -e "RSYNC_PROXY=$RSYNC_PROXY" \
        --entrypoint /bin/bash \
        --rm --name "shield-collector" \
        "securebrowsing/$CONTAINER_TAG" /autorun.sh $NOUPLOAD | tee $RESULTS

    ERR=$(tail -n1 $RESULTS | grep -c $FAILED_STR)

    cat $RESULTS >>"$LOGFILE"

    if ((ERR != 0)); then
        log_message "shield-pre-install-check: Exiting due to previous errors, please check $RESULTS..."
        return 1
    fi
    log_message "shield-pre-install-check passed!"
    return 0
}

#Check if curl is installed (-w check that the whole word is found)
if [ $(dpkg -l | grep -w -c curl) -eq 0 ]; then
    echo "***************     Installing curl"
    apt-get --assume-yes -y install curl
fi

if [ "$CONTAINER_TAG" = "" ]; then
    CONTAINER_TAG="$CONTAINER_TAG_DEFAULT"
    log_message "Warning: Using default image: $CONTAINER_TAG"
fi

if ! [[ $0 != "$BASH_SOURCE" ]]; then
    echo "***************         Ericom Shield Pre-Install Check ..."
    echo "***************         "
    echo "***************         This script validates customer's environment and assess if it is ready for Ericom Shield Installation."
    echo "***************         The script checks for known misconfigurations and HW/OS issues"
    echo "***************         It provides on screen report of known issues and in addition a log report which can help with further trouble shooting."
    echo "***************         "

    install_docker

    perform_env_test

    RET_VALUE=$?
    exit $RET_VALUE
fi
