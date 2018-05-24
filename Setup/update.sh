#!/bin/bash
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
ES_PATH="/usr/local/ericomshield"
ES_BACKUP_PATH="/usr/local/ericomshield/backup"
LOGFILE="$ES_PATH/ericomshield.log"
ES_VER_FILE="$ES_PATH/shield-version.txt"
ES_PRE_CHECK_FILE="$ES_PATH/shield-pre-install-check.sh"
ES_DEV_FILE="$ES_PATH/.esdev"
ES_STAGING_FILE="$ES_PATH/.esstaging"
ES_CHANNEL=""
ES_VERSION_ARG=""
UPDATE_LOG_FILE="$ES_PATH/lastoperation.log"
ES_CONFIG_FILE="$ES_PATH/docker-compose.yml"
VERSION_REGEX="SHIELD_VER=([a-zA-Z0-9_:]+)"
ES_BRANCH_FILE="$ES_PATH/.esbranch"

cd "$ES_PATH" || exit

ARGS="${@}"
if [ "$ARGS" = "" ]; then
   ARGS="update"
fi

case "${ARGS[@]}" in
    *"auto"*)
        AUTOUPDATE=true
        ;;
esac

if [ ! -f "$ES_PATH/ericomshield_key" ]; then
    echo "Please run ./update.sh sshkey first"
    exit 0
fi

if [ -n "$AUTOUPDATE" ]; then
    remove=auto
    ARGS=("${ARGS[@]/$remove}")
fi

function set_channel_mode() {
    if [ -f "$ES_STAGING_FILE" ]; then
      ES_CHANNEL="--staging"
   fi
   if [ -f "$ES_DEV_FILE" ]; then
      ES_CHANNEL="--dev"
   fi
}

# if command is update (from cli or based on the previous ifs, then check the channel based on the file) - should be handled in the container
if [ "$ARGS" = "update" ]; then
    set_channel_mode
fi

if [ ! -f "$ES_VER_FILE" ]; then
   echo "$(date): Ericom Shield Update: Cannot find version file" >>"$LOGFILE"
   exit 1
fi

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -v | --version)
        BRANCH=$2
        echo $BRANCH > "$ES_BRANCH_FILE"
        if [ -z "$ES_CHANNEL" ]; then
            set_channel_mode
        fi
        ;;
    --dev)
        ES_CHANNEL="--dev"
        ;;
    --staging)
        ES_CHANNEL="--staging"
        ;;
    --verbose)
        FULL_OUTPUT="--verbose"
        ;;
    --keep-docker-version)
        KEEP_DOCKER="yes"
        ;;
    -f | --force)
        FORCE_RUN="yes"
        ;;
    esac
    shift
done

function get_latest_version() {
    cd "$ES_PATH"
    mv "$ES_VER_FILE" "$ES_VER_FILE".bak

    source "$ES_PATH"/ericomshield-repo.sh
    if [ "$ES_CHANNEL" = "--staging" ]; then
        VERSION_FILE_PATH="$ES_repo_staging_ver"
    fi

    if [ "$ES_CHANNEL" = "--dev" ]; then
        VERSION_FILE_PATH="$ES_repo_dev_ver"
    fi

    if [ -z "$VERSION_FILE_PATH" ]; then
        VERSION_FILE_PATH="$ES_repo_ver"
    fi

    echo "$VERSION_FILE_PATH"
    curl -s -S -o "$ES_VER_FILE" "$VERSION_FILE_PATH"

    if [ ! -f "$ES_VER_FILE" ]; then
        echo "Download version file failed. Please check shield version is correct"
        exit 1
    fi
}

function read_current_version() {
    ver=$(cat "$ES_CONFIG_FILE" | grep "SHIELD_VER=")
    if [[ $ver =~ $VERSION_REGEX ]]; then
        CURRENT_SHIELD_VERSION="${BASH_REMATCH[1]}"
    fi
}

if [ -z "$BRANCH" ]; then
    if [ -f "$ES_BRANCH_FILE" ]; then
      BRANCH=$(cat "$ES_BRANCH_FILE")
      ES_VERSION_ARG="-v $BRANCH"
     else
      BRANCH="master"
    fi  
fi

get_latest_version
if [ -z "$FORCE_RUN" ]; then
    read_current_version
    NEXT_SHIELD_VERSION=$(cat shield-version.txt | grep SHIELD_VER | cut -d' ' -f2 | cut -d'=' -f2)
    if [ "$CURRENT_SHIELD_VERSION" = "$NEXT_SHIELD_VERSION" ]; then
        echo "Ericom Shield repo version is $NEXT_SHIELD_VERSION"
        echo "Current system version is $CURRENT_SHIELD_VERSION"
        echo "Your EricomShield System is Up to date"
        exit 0
    fi
fi

CONTAINER_TAG="$(grep -r 'shield-autoupdate' $ES_VER_FILE | cut -d' ' -f2)"
if [ "$CONTAINER_TAG" = "" ]; then
   CONTAINER_TAG="shield-autoupdate:180328-06.56-1731"
   echo "Warning: shield-autoupdate not found in $ES_VER_FILE, using default tag"
fi

function wait_upgrade_process_finish() {
    local wait_count=0
    
    while ((wait_count < 60)); do
        {
            VERSION=$(docker version | grep Version | tail -1 | awk '{ print $2 }'  | cut -d'-' -f1)
        } || {
            VERSION="False"
        }
        if [ "$VERSION" = "$1" ]; then
            break
        fi
        echo "Current docker version is $VERSION wait for $1"
        printf "."
        sleep 10
        wait_count=$((wait_count + 1))
    done

    echo "Done!"
}

function upgrade_docker_version() {
    NEXT_VERSION=$(cat "$ES_VER_FILE" | grep 'docker-version' | awk '{ print $2 }')
    CURRENT_VERSION=$(docker info -f '{{ .ServerVersion }}' | cut -d'-' -f1)

    if [ "$NEXT_VERSION" != "" ] && [ "$NEXT_VERSION" != "$CURRENT_VERSION" ]; then
        docker run --rm  $DOCKER_RUN_PARAM \
           -v /var/run/docker.sock:/var/run/docker.sock \
           -v $(which docker):/usr/bin/docker \
           -v /usr/local/ericomshield:/usr/local/ericomshield \
           -e "ES_PRE_CHECK_FILE=$ES_PRE_CHECK_FILE" \
           "securebrowsing/$CONTAINER_TAG" "$FULL_OUTPUT" upgrade

        wait_upgrade_process_finish "$NEXT_VERSION"
    fi
}

echo "***************     Ericom Shield Update ($CONTAINER_TAG, BRANCH=$BRANCH, ARGS=$ARGS, $ES_CHANNEL, $ES_VERSION_ARG) ..."

echo "$(date): Ericom Shield Update: Running Update"

if [ -f "$UPDATE_LOG_FILE" ]; then
    rm -f $UPDATE_LOG_FILE
fi

if [ -z "$AUTOUPDATE"  ]; then
    DOCKER_RUN_PARAM="-it"
fi

if [ -z "$KEEP_DOCKER" ]; then
    upgrade_docker_version
fi

docker run --rm  $DOCKER_RUN_PARAM \
       -v /var/run/docker.sock:/var/run/docker.sock \
       -v $(which docker):/usr/bin/docker \
       -v /usr/local/ericomshield:/usr/local/ericomshield \
       -e "ES_PRE_CHECK_FILE=$ES_PRE_CHECK_FILE" \
       "securebrowsing/$CONTAINER_TAG" $ARGS $ES_CHANNEL $ES_VERSION_ARG
