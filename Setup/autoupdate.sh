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

UPDATE=0
ES_PATH="/usr/local/ericomshield"
ES_REPO_FILE="$ES_PATH/ericomshield-repo.sh"
ES_AUTO_UPDATE_FILE="$ES_PATH/.autoupdate"
ES_DEV_FILE="$ES_PATH/.esdev"
ES_VER_FILE="$ES_PATH/shield-version.txt"

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi
cd $ES_PATH

source $ES_REPO_FILE

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
        sleep $((M_START_S - CURR_S))
    else
        sleep $((M_START_S + 24 * 60 * 60 - CURR_S))
    fi
}

while true; do
    # Maintenance Time is only for Prod environments
    if [ -f "$ES_DEV_FILE" ]; then
        ES_DEV=true
    elif [ "$AUTOUPDATE_ONLY_DURING_MAINTENANCE_TIME" = true ]; then
        wait_for_maintenance_time
    fi

    if [ -f "$ES_AUTO_UPDATE_FILE" ]; then
        echo "Getting shield-version-new.txt"
        if [ "$ES_DEV" == true ]; then
            curl -s -S -o shield-version-new.txt $ES_repo_dev_ver
        else
            curl -s -S -o shield-version-new.txt $ES_repo_ver
        fi
        if [ -f "$ES_VER_FILE" ]; then
            if [ $(diff "$ES_VER_FILE" shield-version-new.txt | wc -l) -eq 0 ]; then
                echo "Your EricomShield System is Up to date"
            else
                echo "***************     New version found!"
                UPDATE=1
            fi
        else
            echo "***************     New version found!!"
            UPDATE=1
        fi
        if [ $UPDATE -eq 1 ]; then
            curl -s -S -o ericomshield-setup.sh $ES_repo_setup
            chmod +x ericomshield-setup.sh
            $ES_PATH/ericomshield-setup.sh
        fi
    fi
    echo "."
    sleep $AUTO_UPDATE_TIME
    echo "-"
    $ES_PATH/status.sh >/dev/null &
    if [ $? -ne 0 ]; then
        echo "ericomshield was not running"
        $ES_PATH/run.sh
    fi
done
