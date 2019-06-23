#!/bin/bash -e
############################################
#####   Ericom Shield Update           #####
###################################LO##BH###

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo "Usage: $0 [OPTIONS] COMMAND [ARGS]..."
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

export BRANCH="master"
export ES_PATH=/usr/local/ericomshield
export ES_CONFIG_FILE="$ES_PATH/docker-compose.yml"
export ES_PRE_CHECK_FILE="$ES_PATH/shield-pre-install-check.sh"
export ES_BRANCH_FILE="$ES_PATH/.esbranch"
export APP_NAME="$0"
DOCKER_USER="ericomshield1"
DOCKER_SECRET="Ericom98765$"

if [ -f "$ES_PATH/.esbranch" ]; then
    BRANCH=$(cat "$ES_PATH/.esbranch")
fi

function docker_login() {
    echo "$DOCKER_SECRET" | docker login --username=$DOCKER_USER --password-stdin
}

if [ ! -d ~/.docker ]; then
   if [ -d /root/.docker ]; then
      CURRENT_USERNAME=$(whoami)
      cp -r /root/.docker ~/
      chown -R $CURRENT_USERNAME:$CURRENT_USERNAME ~/.docker
   else
       docker_login
   fi
fi

ARGS="${@}"

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -v | --version)
        BRANCH="$2"
        ;;

    --verbose)
        VERBOSE="--verbose"
        ;;
    esac
    shift
done

MAIN_SCRIPT_URL="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/update.py"

cd "$ES_PATH"

RETURN_CODE=$(curl -so /dev/null -w '%{response_code}' "$MAIN_SCRIPT_URL")
if [ "$RETURN_CODE" != "200" ]; then
    MAIN_SCRIPT_URL="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/update.sh"
    RETURN_CODE=$(curl -so /dev/null -w '%{response_code}' "$MAIN_SCRIPT_URL")

    if [ "$RETURN_CODE" != "200" ]; then
        echo "$BRANCH does not exist. Please run sudo $0 --list-versions"
        exit 1
    else
        curl -s -S -o "update-old.sh" "$MAIN_SCRIPT_URL"
        chmod +x update-old.sh
        if [ -n "$VERBOSE" ]; then
            remove="--verbose"
            ARGS=("${ARGS[@]/$remove/}")
        fi
        SCRIPT="./update-old.sh $VERBOSE update"
    fi
else
    curl -s -S -o "update.py" "$MAIN_SCRIPT_URL"
    SCRIPT="/usr/bin/python3 update.py"
fi

$SCRIPT $ARGS
