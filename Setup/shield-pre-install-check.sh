#!/bin/bash
#################################################
#####   Ericom Shield Pre-Install-Check     #####
############################################BH###

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo "Usage: $0"
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

DOCKER_VERSION="${DOCKER_VERSION:-17.12.1}"
LOGFILE="${LOGFILE:-./shield-pre-install-check.log}"
ES_repo_ver="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/master/Setup/shield-version-dev.txt"
ES_VER_FILE="./shield-version.txt"
RESULTS="./results-pre-check.log"
FAILED_STR="failed"
NOUPLOAD=""

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

    if [ "$(sudo docker version | grep -c $DOCKER_VERSION)" -le 1 ]; then
        echo "***************     Installing docker-engine"
        apt-get --assume-yes -y install apt-transport-https software-properties-common python-software-properties

        #Docker Installation of a specific Version
        curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        echo -n "apt-get -qq update ..."
        apt-get -qq update
        echo "done"
        sudo apt-cache policy docker-ce
        log_message "Installing Docker: docker-ce=$DOCKER_VERSION~ce-0~ubuntu"
        sudo apt-get -y --assume-yes --allow-downgrades install docker-ce=$DOCKER_VERSION~ce-0~ubuntu
    else
        echo " ******* docker-engine $DOCKER_VERSION is already installed"
    fi
    if [ "$(sudo docker version | grep -c $DOCKER_VERSION)" -le 1 ]; then
        log_message "Failed to Install/Update Docker, Exiting!"
        exit -1
    fi
  }
fi

function perform_env_test() {
    local ERR=0

    CONTAINER_TAG="$(grep -r 'shield-collector' "$ES_VER_FILE" | cut -d' ' -f2)"

    docker run --privileged -it \
           --volume "/var/run/docker.sock:/var/run/docker.sock" \
           --volume "/dev:/hostdev" --volume "/proc:/hostproc" \
           --rm --name "shield-collector" \
           "securebrowsing/$CONTAINER_TAG" /bin/bash /autorun.sh | tee $RESULTS

    ERR=$(tail -n1 $RESULTS | grep -c $FAILED_STR)

    if ((ERR != 0)); then
        log_message "shield-pre-install-check: Exiting due to previous errors..."
        return 1
    fi
    log_message "shield-pre-install-check passed!"
    return 0
}

#Check if curl is installed (-w check that the whole word is found)
if [ "$(dpkg -l | grep -w -c curl)" -eq 0 ]; then
    echo "***************     Installing curl"
    apt-get --assume-yes -y install curl
fi

if [ ! -f "$ES_VER_FILE" ]; then
    curl -s -S -o "$ES_VER_FILE" "$ES_repo_ver"
    if [ ! -f "$ES_VER_FILE" ] || [ $(grep -c '404' "$ES_VER_FILE") -ge 1 ]; then
        log_message "Cannot Retrieve Ericom Shield version file"
        exit 1
    fi
fi

install_docker

if ! [[ $0 != "$BASH_SOURCE" ]]; then
    set -e
    ES_INTERACTIVE=true

    echo "***************     Ericom Shield Pre-Install Check ..."
    echo "***************     "
    echo "***************     This script validates customer's environment and assess if it is ready for Ericom Shield Installation."
    echo "***************     The script checks for known misconfigurations and HW/OS issues"
    echo "***************     It provides on screen report of known issues and in addition a log report which can help with further trouble shooting."
    echo "***************     "
    read -p "Do you agree to send the pre-check results anonymously to Ericom (yes/no) )?" choice;
    case "$choice" in
       "y" | "yes" | "YES" | "Yes")
            NOUPLOAD=""
            echo "yes"
            break
            ;;
        "n" | "no" | "NO" | "No")
            NOUPLOAD="#noUpload"
            break
            ;;
        *) ;;
    esac

    perform_env_test
    RET_VALUE=$?
    exit $RET_VALUE
fi
