#!/bin/bash
################################################
#####   Ericom Shield Installer:add_repo   #####
###########################################BH###

SHIELD_REPO_URL="https://helmrepo.shield-service.net"
SHIELD_REPO="$SHIELD_REPO_URL/master"
NOT_FOUND_STR="404: Not Found"

PASSWORD=""
ES_PATH="$HOME/ericomshield"
ES_BRANCH_FILE="$ES_PATH/.esbranch"
LOGFILE=last_deploy.log

function usage() {
    echo " Usage: $0 -p <PASSWORD> [-d|--dev] [-s|--staging] [-v|--version <version-name>] [-l|--list-versions]"
}

function log_message() {
    local PREV_RET_CODE=$?
    echo "$@"
    echo "$(LC_ALL=C date): $@" >>"$LOGFILE"
    if ((PREV_RET_CODE != 0)); then
        return 1
    fi
    return 0
}

function download_and_check() {
    curl -s -S -o "$1" "$2"
    if [ ! -f "$1" ] || [ $(grep -c "$NOT_FOUND_STR" "$1") -ge 1 ]; then
        echo "Error: cannot download "$1", exiting"
        exit 1
    fi
}

function list_versions() {
    ES_repo_versions="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Dev/Setup/Releases-kube.txt"
    echo "Getting $ES_repo_versions"
    download_and_check "Releases.txt" $ES_repo_versions

    while true; do
        cat Releases.txt | cut -d':' -f1
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
        "5")
            echo "5."
            OPTION="5)"
            break
            ;;
        *)
            echo "Error: Not a valid option, exiting"
            ;;
        esac
    done
    grep "$OPTION" Releases.txt
    BRANCH=$(grep "$OPTION" Releases.txt | cut -d':' -f3)
    echo -n $BRANCH >"$ES_BRANCH_FILE"
    REPO=$(grep "$OPTION" Releases.txt | cut -d':' -f2)
    SHIELD_REPO="$SHIELD_REPO_URL/$REPO"

    echo "$SHIELD_REPO" "$BRANCH"
}

if [ -f "$ES_BRANCH_FILE" ]; then
    BRANCH=$(cat "$ES_BRANCH_FILE")
fi

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -p | --password)
        shift
        PASSWORD=$1
        ;;
    -v | --version)
        shift
        SHIELD_REPO="$SHIELD_REPO_URL/$1"
        ;;
    -d | --dev) # Dev Channel (dev branch)
        SHIELD_REPO="$SHIELD_REPO_URL/dev"
        echo -n "Dev" >"$ES_BRANCH_FILE"
        ;;
    -s | --staging) # Staging Channel (staging Branch)
        SHIELD_REPO="$SHIELD_REPO_URL/staging"
        echo -n "Staging" >"$ES_BRANCH_FILE"
        ;;
    -l | --list-versions)
        list_versions
        ;;
    *)
        usage "$0"
        exit
        ;;
    esac
    shift
done

if [ "$PASSWORD" == "" ]; then
    echo " Error: Password is missing"
    usage
    exit
fi

helm repo add shield-repo --username=ericom --password=$PASSWORD $SHIELD_REPO
helm repo update

helm search shield
