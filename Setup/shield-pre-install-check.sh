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
ES_repo_ver="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/master/Setup/shield-version-staging.txt"
ES_VER_PIC_FILE="./shield-version-pic.txt"
RESULTS="./results-pre-check.log"
UPLOAD_ACCEPTED_FILE="$ES_PATH/.upload_accepted"
FAILED_STR="failed"
NOT_FOUND_STR="404: Not Found"
NOUPLOAD=""
DOCKER_USER="ericomshield1"
DOCKER_SECRET="Ericom98765$"

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

if ! declare -f docker_login >/dev/null; then
    function docker_login() {
        if [ "$(docker info | grep -c Username)" -eq 0 ]; then
            #Login and enter the credentials you received separately when prompt
            echo "docker login" $DOCKER_USER $DOCKER_SECRET
            docker login --username=$DOCKER_USER --password=$DOCKER_SECRET
            if [ $? == 0 ]; then
                echo "Login Succeeded!"
            else
                log_message "Cannot Login to docker, Exiting!"
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
                NOUPLOAD="#noUpload"
                break
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
            NOUPLOAD="#noUpload"
            echo "no"
        fi
    fi

    docker run --privileged -it \
        --volume "/var/run/docker.sock:/var/run/docker.sock" \
        --volume "/dev:/hostdev" --volume "/proc:/hostproc" \
        --volume "/:/hostroot" \
        --rm --name "shield-collector" \
        "securebrowsing/$CONTAINER_TAG" /bin/bash /autorun.sh | tee $RESULTS

    ERR=$(tail -n1 $RESULTS | grep -c $FAILED_STR)

    cat $RESULTS >>"$LOGFILE"

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

curl -s -S -o "$ES_VER_PIC_FILE" "$ES_repo_ver"
if [ ! -f "$ES_VER_PIC_FILE" ] || [ $(grep -c "$NOT_FOUND_STR" "$ES_VER_PIC_FILE") -ge 1 ]; then
    log_message "Cannot Retrieve Ericom Shield version file: $ES_repo_ver"
    exit 1
fi
CONTAINER_TAG="$(grep -r 'shield-collector' "$ES_VER_PIC_FILE" | cut -d' ' -f2)"

if ! [[ $0 != "$BASH_SOURCE" ]]; then
    set -e
    ES_INTERACTIVE=true

    echo "***************         Ericom Shield Pre-Install Check ..."
    echo "***************         "
    echo "***************         This script validates customer's environment and assess if it is ready for Ericom Shield Installation."
    echo "***************         The script checks for known misconfigurations and HW/OS issues"
    echo "***************         It provides on screen report of known issues and in addition a log report which can help with further trouble shooting."
    echo "***************         "

    install_docker

    docker_login

    perform_env_test

    RET_VALUE=$?
    exit $RET_VALUE
fi
