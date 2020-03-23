#!/bin/bash
############################################
#####   Ericom Shield Install In Docker  ###
#######################################BH###

ES_PATH="$HOME/ericomshield"
BRANCH="master"
NOT_FOUND_STR="404: Not Found"
LOGFILE="$ES_PATH/ericomshield.log"
ES_repo_docker="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/install-docker.sh"
ES_file_docker="install-docker.sh"
DOCKER_USER="ericomshield1"
DOCKER_SECRET="Ericom98765$"
SHIELD_CLI='shield-cli'
SHIELD_CMD="/usr/bin/$SHIELD_CLI"
VERSION="Rel-20.03.632"
ES_file_install_shield_local="install-shield-local.sh"

function usage() {
    echo " Usage: $0  [-h|--help]"
}

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

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -h | --help)
#    *)
        usage
        exit
        ;;
    esac
    shift
done

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

function docker_login() {
    if [ "$(docker info | grep -c Username)" -eq 0 ]; then
       echo "docker login" $DOCKER_USER
       echo "$DOCKER_SECRET" | docker login --username=$DOCKER_USER --password-stdin
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
docker_login

DOCKER_BIN=$(which docker)
SHIELD_CLI_DOCKER_CMD="sudo docker run --rm -it --privileged \
                  -v $HOME/.kube:/home/ericom/.kube \
                  -v /var/run/docker.sock:/var/run/docker.sock \
                  -v $DOCKER_BIN:/usr/bin/docker --user 1000:$DOCKER_GID securebrowsing/es-shield-cli:$VERSION bash"

echo "$SHIELD_CLI_DOCKER_CMD" > $SHIELD_CMD
chmod +x $SHIELD_CMD

SHIELD_DOCKER_CMD="docker run --rm -d -it --name shield-cli --privileged \
                  -v $HOME/.kube:/home/ericom/.kube \
                  -v /var/run/docker.sock:/var/run/docker.sock \
                  -v $DOCKER_BIN:/usr/bin/docker --user 1000:$DOCKER_GID securebrowsing/es-shield-cli:$VERSION bash"

if [ $(docker ps -a | grep -c shield-cli) -lt 1 ]; then
   $SHIELD_DOCKER_CMD $@
fi
cd "$HOME"

docker cp shield-cli:/home/ericom/ericomshield .

cd "$ES_PATH"

"./$ES_file_install_shield_local" $@

docker rm -f shield-cli
