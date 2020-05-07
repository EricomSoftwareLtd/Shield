#!/bin/bash
############################################
#####   Ericom Shield Install In Docker  ###
#######################################BH###

ES_PATH="$HOME/ericomshield"
NOT_FOUND_STR="404: Not Found"
LOGFILE="$ES_PATH/ericomshield.log"
ES_repo_docker="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/master/Kube/scripts/install-docker.sh"
ES_file_docker="install-docker.sh"
ES_repo_versions="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/master/Shield-Releases.txt"
ES_repo_versions_file="shield-releases.txt"
DOCKER_USER="ericomshield1"
PASSWORD=""
SHIELD_CLI='shield-cli'
SHIELD_CMD="/usr/bin/$SHIELD_CLI"
VERSION="master"
ES_VERSION_FILE="$ES_PATH/.esversion"
ES_file_install_shield_local="install-shield-local.sh"
ES_file_prepare_servers="shield-prepare-servers"

function usage() {
    echo " Usage: $0 -p <PASSWORD> [-d|--dev] [-s|--staging] [-v|--version <version-name>] [-r|--releases] [--registry <Shield-Registry-IP:Port>] [-l|--label] [-h|--help]"
}

#Check if we are root
if ((EUID != 0)); then
    # sudo su
    usage
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

# Create the Ericom empty dir if necessary
if [ ! -d $ES_PATH ]; then
    mkdir -p $ES_PATH
    chmod 0755 $ES_PATH
fi

cd "$ES_PATH" || exit 1

function log_message() {
    local PREV_RET_CODE=$?
    echo "$@"
    if [ -f "$LOGFILE" ]; then
        echo "$(LC_ALL=C date): $@" >>"$LOGFILE"
        if ((PREV_RET_CODE != 0)); then
            return 1
        fi
    fi
    return 0
}

# download TO (local-file) FROM (remote-url)
# [+x] chmod executable
function download_and_check() {
    curl -sL -S -o "$1" "$2"
    if [ ! -f "$1" ] || [ $(grep -c -x "$NOT_FOUND_STR" "$1") -ge 1 ]; then
        log_message "Error: cannot download "$2", exiting"
        exit 1
    fi
    if [ "$3a" = "+xa" ]; then
        chmod +x "$1"
    fi
}

function list_versions() {
    echo "Getting $ES_repo_versions"
    download_and_check $ES_repo_versions_file $ES_repo_versions

    if [ ! -z "$1" ]; then
      OPTION="$1"
    fi

    while [ -z "$OPTION" ]; do
        cat $ES_repo_versions_file | cut -d':' -f1 | grep -v Dev | grep -v Staging
        read -p "Please select the Release you want to install/update (1-4):" choice
        case "$choice" in
        "1" | "latest")
            echo 'latest'
            OPTION="1)"
            break
            ;;
        "2")
            echo "2."
            OPTION="2)"
            break
            ;;
        "3")
            echo "3."
            OPTION="3)"
            break
            ;;
        "4")
            echo "4."
            OPTION="4)"
            break
            ;;
        *)
            echo "Error: Not a valid option, exiting"
            exit
            ;;
        esac
    done
    grep "$OPTION" $ES_repo_versions_file
    VERSION=$(grep "$OPTION" $ES_repo_versions_file | cut -d':' -f2)
    if [ -z "$VERSION" ]; then
      log_message "Cannot find Version, exiting"
      exit 1
    fi 
    echo -n $VERSION >"$ES_VERSION_FILE"
}

args="$@"

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -p | --password)
        shift
        PASSWORD="$1"
        ;;
    -v | --version)
        shift
        echo -n "$1" >"$ES_VERSION_FILE"
        ;;
    -d | --dev) # Dev Channel
        list_versions "Dev"
        ;;
    -s | --staging) # Staging Channel
        list_versions "Staging"
        ;;
    -r | --releases) # List the official releases
        list_versions
        ;;
    --registry) # Specify Offline Registry address and port
        shift
        export ES_OFFLINE_REGISTRY="$1"
        ;;
    -h | --help)
        #    *)
        usage "$0"
        exit
        ;;
    esac
    shift
done

if [ ! -z "$ES_OFFLINE_REGISTRY" ]; then
    ES_OFFLINE_REGISTRY_PREFIX="$ES_OFFLINE_REGISTRY/"
fi

if [ -f "$ES_VERSION_FILE" ]; then
    VERSION=$(cat "$ES_VERSION_FILE")
fi

echo "Version:" "$VERSION"

if [ -z "$ES_OFFLINE_REGISTRY" ] && [ "$PASSWORD" == "" ]; then
    echo " Error: Password is missing"
    usage
    exit 1
fi

function docker_login() {
    if [ "$(docker info | grep -c Username)" -eq 0 ]; then
        echo "docker login" $DOCKER_USER
        echo "$PASSWORD" | docker login --username=$DOCKER_USER --password-stdin
        if [ $? == 0 ]; then
            echo "Login Succeeded!"
        else
            log_message "Cannot Login to docker, exiting"
            exit -1
        fi
    fi
}

DOCKER_GID=$(getent group docker | awk -F: '{print $3}')

if [ ! -x "/usr/bin/docker" ]; then
    download_and_check "$ES_file_docker" "$ES_repo_docker" "+x"
    log_message "***************     Installing Docker"
    source "./$ES_file_docker"
    if [ $? != 0 ]; then
        log_message "*************** $ES_file_docker Failed, Exiting!"
        exit 1
    fi
fi

if [ -z "$ES_OFFLINE_REGISTRY" ]; then
    docker_login
else
    if [ ! -d /etc/docker ]; then
        mkdir /etc/docker
    fi
    cat >/etc/docker/daemon.json <<EOF
{
  "insecure-registries": ["$ES_OFFLINE_REGISTRY"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "10" 
  }
}
EOF
    systemctl reload docker
fi

#TODO: Check if Docker Tag exists if not error

docker image pull "${ES_OFFLINE_REGISTRY_PREFIX}securebrowsing/es-shield-cli:$VERSION"
if [ $(docker image ls | grep -c $VERSION) -lt 1 ]; then
    echo
    echo "Error: Cannot Pull Docker image es-shield-cli: $VERSION"
    echo "  Verify the version exists and the password is correct "
    exit 1
fi

DOCKER_BIN=$(which docker)
SHIELD_CLI_DOCKER_CMD="sudo docker run --rm -it --privileged \
                  -v $HOME/.kube:/home/ericom/.kube \
                  -v /var/run/docker.sock:/var/run/docker.sock \
                  -v $DOCKER_BIN:/usr/bin/docker --user 1000:$DOCKER_GID ${ES_OFFLINE_REGISTRY_PREFIX}securebrowsing/es-shield-cli:$VERSION bash"

echo "$SHIELD_CLI_DOCKER_CMD" >$SHIELD_CMD
chmod +x $SHIELD_CMD

SHIELD_DOCKER_CMD="docker run --rm -d -it --name shield-cli --privileged \
                  -v $HOME/.kube:/home/ericom/.kube \
                  -v /var/run/docker.sock:/var/run/docker.sock \
                  -v $DOCKER_BIN:/usr/bin/docker --user 1000:$DOCKER_GID ${ES_OFFLINE_REGISTRY_PREFIX}securebrowsing/es-shield-cli:$VERSION bash"

if [ $(docker ps -a | grep -c shield-cli) -lt 1 ]; then
    $SHIELD_DOCKER_CMD $@
fi

cd "$HOME"

if [ "$(ls $ES_PATH/*.yaml | wc -l)" -ge "1" ]; then
    echo "Keeping Custom Yaml"
    mkdir -p /tmp/yaml
    mv $ES_PATH/*.yaml /tmp/yaml/
    docker cp shield-cli:/home/ericom/ericomshield .
    mv /tmp/yaml/*.yaml $ES_PATH
else
    docker cp shield-cli:/home/ericom/ericomshield .
fi

docker cp shield-cli:/usr/bin/kubectl   /usr/local/bin/
docker cp shield-cli:/usr/bin/helm      /usr/local/bin/
docker cp shield-cli:/usr/bin/rancher   /usr/local/bin/

export PATH="/usr/local/bin:$PATH"

cd "$ES_PATH"

if [ ! -z "$ES_OFFLINE_REGISTRY" ]; then
    ./$ES_file_prepare_servers add-registry "$ES_OFFLINE_REGISTRY" ./shield
fi

"./$ES_file_install_shield_local" $args

docker rm -f shield-cli
