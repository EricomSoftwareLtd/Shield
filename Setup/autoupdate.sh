#!/bin/bash
############################################
#####   Ericom Shield AutoUpdate       #####
#######################################BH###

#  If you are not using ericomshield service, run this script in the background
#  sudo nohup ./autoupdate.sh > /dev/null &

MAINTENANCE_START="00:00"
MAINTENANCE_END="06:00"
AUTOUPDATE_ONLY_DURING_MAINTENANCE_TIME=true
AUTO_UPDATE_TIME=5m

FORCE_CHECK=false
UPDATE=false
ES_PATH="/usr/local/ericomshield"
ES_REPO_FILE="$ES_PATH/ericomshield-repo.sh"
ES_AUTO_UPDATE_FILE="$ES_PATH/.autoupdate"
ES_VER_FILE="$ES_PATH/shield-version.txt"
ES_VER_FILE_NEW="$ES_PATH/shield-version-new.txt"
LOGFILE="$ES_PATH/ericomshield.log"
ES_BRANCH_FILE="$ES_PATH/.esbranch"
DEV_BRANCH="Dev"

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi
cd $ES_PATH

source $ES_REPO_FILE

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -f | --force)
        AUTOUPDATE_ONLY_DURING_MAINTENANCE_TIME=false
        FORCE_CHECK=true
        ;;
    #    -h | --help)
    *)
        echo "Usage: $0 [-f | --force] [-h | --help]"
        exit
        ;;
    esac
    shift
done

function wait_for_maintenance_time() {
    M_START_S=$(date -d "$(date -I)T${MAINTENANCE_START}" +"%s") #"
    M_END_S=$(date -d "$(date -I)T${MAINTENANCE_END}" +"%s")     #"
    if ((M_END_S < M_START_S)); then
        M_END_S=$((M_END_S + 24 * 60 * 60))
    fi
    CURR_S=$(date +"%s")
    if ((M_START_S <= CURR_S)) && ((CURR_S <= M_END_S)); then
        return
    elif ((M_START_S > CURR_S)); then
        echo "Waiting for maintenance time (run with -f to run it immediately)..."
        sleep $((M_START_S - CURR_S))
    else
        echo "Waiting for maintenance time (run with -f to run it immediately)..."
        sleep $((M_START_S + 24 * 60 * 60 - CURR_S))
    fi
}

function am_i_leader() {
    AM_I_LEADER=$(docker node inspect $(hostname) --format "{{ .ManagerStatus.Leader }}" | grep "true")
}

while true; do
    # Maintenance Time is only for Prod environments
    if [ -f "$ES_BRANCH_FILE" ] && [ $(grep -c "$DEV_BRANCH" "$ES_BRANCH_FILE") -ge 1 ]; then
        ES_DEV=true
    elif [ "$AUTOUPDATE_ONLY_DURING_MAINTENANCE_TIME" == true ]; then
        wait_for_maintenance_time
    fi

    if [ -f "$ES_AUTO_UPDATE_FILE" ] || [ "$FORCE_CHECK" == true ]; then
        am_i_leader
        if [ "$FORCE_CHECK" == true ]; then
            FORCE_UPDATE="--force"
        fi

        if [ "$AM_I_LEADER" == true ]; then
            export AUTO=true
            $ES_PATH/update.sh "$FORCE_UPDATE"
        else
            echo "This process must be executed on a leader node. Process cannot be completed."
        fi
    fi
    if [ "$FORCE_CHECK" == true ]; then
        break
    fi
    echo "."
    sleep $AUTO_UPDATE_TIME
    echo "-"
    UPDATE=false
done
