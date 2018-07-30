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

case "$1" in
-h | --help)
    echo "Usage: update.sh [OPTIONS] [COMMAND] [OPTIONS]"
    echo "--verbose Switch to detailed output"
    echo "-list-versions  Show available version to update"
    echo ""
    echo "Commands:"
    echo "sshkey Make ssh key to connect to swarm hosts"
    echo "update Update docker/shield command"
    exit 0
    ;;
esac

ES_PATH="/usr/local/ericomshield"
ES_BACKUP_PATH="/usr/local/ericomshield/backup"
LOGFILE="$ES_PATH/ericomshield.log"
ES_VER_FILE="$ES_PATH/shield-version.txt"
ES_PRE_CHECK_FILE="$ES_PATH/shield-pre-install-check.sh"
ES_VERSION_ARG=""
UPDATE_LOG_FILE="$ES_PATH/lastoperation.log"
ES_CONFIG_FILE="$ES_PATH/docker-compose.yml"
VERSION_REGEX="SHIELD_VER=([a-zA-Z0-9_:\.-]+)"
ES_BRANCH_FILE="$ES_PATH/.esbranch"
DEV_BRANCH="Dev"
STAGING_BRANCH="Staging"
CONTAINER_TAG_DEFAULT="shield-autoupdate:180711-14.26-2510"
NOT_FOUND_STR="404: Not Found"

cd "$ES_PATH" || exit

ARGS="${@}"
if [ "$ARGS" = "" ]; then
    ARGS="update"
fi

case "${ARGS[@]}" in
*"auto"*)
    AUTOUPDATE=true
    ;;

*"sshkey"*)
    KEY_INSTALL="yes"
    ;;
esac

if [ ! -f "$ES_PATH/ericomshield_key" ] && [ -z "$KEY_INSTALL" ]; then
    echo "Please run ./update.sh sshkey first"
    exit 0
fi

if [ -n "$AUTOUPDATE" ]; then
    remove=auto
    ARGS=("${ARGS[@]/$remove/}")
fi

function list_versions() {
    ES_repo_versions="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/master/Setup/Releases.txt"
    echo "Getting $ES_repo_versions"
    curl -s -S -o "Releases.txt" $ES_repo_versions

    if [ ! -f "Releases.txt" ] || [ $(grep -c "$NOT_FOUND_STR" Releases.txt) -ge 1 ]; then
        echo "Error: cannot download Release.txt, exiting"
        exit 1
    fi

    cat Releases.txt | cut -d':' -f1

    read -p "please select the Release you want to update:" choice
    case "$choice" in
    "1" | "latest")
        echo 'latest'
        OPTION="1)"
        ;;
    "2")
        echo "2."
        OPTION="2)"
        ;;
    "3")
        echo "3."
        OPTION="3)"
        ;;
    "4")
        echo "4."
        OPTION="4)"
        ;;
    *)
        echo "Error: Not valid option, exiting"
        exit 1
        ;;
    esac
    echo "$OPTION"
    grep "$OPTION" Releases.txt
    BRANCH=$(grep "$OPTION" Releases.txt | cut -d':' -f2)
    echo "$BRANCH" > "$ES_BRANCH_FILE"
}

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -v | --version)
        BRANCH=$2
        echo $BRANCH >"$ES_BRANCH_FILE"
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
    -h | --help)
        HELP_ASKED="yes"
        ;;
    -list-versions)
        list_versions
        read -p "To continue update press 1 to stop press 2:" choice
        case "$choice" in
        "1")
            ./update.sh update
            ;;
        "2")
            exit 0
            ;;
        *)
            echo "Error: Not valid option, exiting"
            exit 1
            ;;
        esac
        exit 0
    esac
    shift
done

function get_latest_version() {
    cd "$ES_PATH"
    mv "$ES_VER_FILE" "$ES_VER_FILE".bak

    source "$ES_PATH"/ericomshield-repo.sh

    if [ -z "$VERSION_FILE_PATH" ]; then
        VERSION_FILE_PATH="$ES_repo_ver"
    fi

    echo "$VERSION_FILE_PATH"
    curl -s -S -o "$ES_VER_FILE" "$VERSION_FILE_PATH"

    if [ -n "$KEY_INSTALL" ]; then
        BRANCH=""
        ES_VERSION_ARG=""
    fi

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

if [ -z "$HELP_ASKED" ]; then
    get_latest_version
else
    ES_VERSION_ARG=''
fi

if [ -z "$FORCE_RUN" ] && [ -z "$KEY_INSTALL" ]; then
    read_current_version
    NEXT_SHIELD_VERSION=$(cat shield-version.txt | grep SHIELD_VER | cut -d' ' -f2 | cut -d'=' -f2)
    if [[ $CURRENT_SHIELD_VERSION == "$NEXT_SHIELD_VERSION" && -z $HELP_ASKED ]]; then
        echo "Ericom Shield repo version is $NEXT_SHIELD_VERSION"
        echo "Current system version is $CURRENT_SHIELD_VERSION"
        echo "Your EricomShield System is Up to date"
        exit 0
    fi
fi

CONTAINER_TAG="$(grep -r 'shield-autoupdate' $ES_VER_FILE | cut -d' ' -f2)"
if [ "$CONTAINER_TAG" = "" ]; then
    CONTAINER_TAG="$CONTAINER_TAG_DEFAULT"
    echo "$(date): Warning: shield-autoupdate not found in $ES_VER_FILE, using default tag" >>"$LOGFILE"
fi

function wait_upgrade_process_finish() {
    local wait_count=0

    while ((wait_count < 60)); do
        {
            VERSION=$(docker version | grep Version | tail -1 | awk '{ print $2 }' | cut -d'-' -f1)
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
    sleep 20
}

function upgrade_docker_version() {
    NEXT_VERSION=$(cat "$ES_VER_FILE" | grep 'docker-version' | awk '{ print $2 }')
    CURRENT_VERSION=$(docker info -f '{{ .ServerVersion }}' | cut -d'-' -f1)

    if [[ ($NEXT_VERSION != "" && $NEXT_VERSION != "$CURRENT_VERSION" && -z $KEY_INSTALL && -z $HELP_ASKED) || ( $FORCE_RUN == "yes" && -z "$HELP_ASKED" ) ]]; then
        docker run --rm $DOCKER_RUN_PARAM \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v $(which docker):/usr/bin/docker \
            -v /usr/local/ericomshield:/usr/local/ericomshield \
            -e "ES_PRE_CHECK_FILE=$ES_PRE_CHECK_FILE" \
            "securebrowsing/$CONTAINER_TAG" $FULL_OUTPUT upgrade

        wait_upgrade_process_finish "$NEXT_VERSION"
    fi
}

echo "***************     Ericom Shield Update ($CONTAINER_TAG, BRANCH=$BRANCH, ARGS=$ARGS, $ES_VERSION_ARG) ..."

echo "$(date): Ericom Shield Update: Running Update"

if [ -f "$UPDATE_LOG_FILE" ]; then
    rm -f $UPDATE_LOG_FILE
fi

if [ -z "$AUTOUPDATE" ]; then
    DOCKER_RUN_PARAM="-it"
fi

if [ -z "$KEEP_DOCKER" ] && [ -z "$KEY_INSTALL" ]; then
    upgrade_docker_version
fi

docker run --rm $DOCKER_RUN_PARAM \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $(which docker):/usr/bin/docker \
    -v /usr/local/ericomshield:/usr/local/ericomshield \
    -e "ES_PRE_CHECK_FILE=$ES_PRE_CHECK_FILE" \
    "securebrowsing/$CONTAINER_TAG" $ARGS $ES_VERSION_ARG
