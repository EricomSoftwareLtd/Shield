#!/bin/bash

# set -ex

###########################################
#####   Ericom Shield Installer        #####
###################################LO##BH###
NETWORK_INTERFACE='eth0'
SINGLE_MODE=true
STACK_NAME='shield'
ES_YML_FILE=docker-compose.yml
HOST=$(hostname)
SECRET_UID="shield-system-id"

RESOLV_FILE="/etc/resolv.conf"
PROXY_ENV_FILE="proxy-server.env"

#For bckwrd-compatibility and Jenkins
if [ ! -f "$ES_YML_FILE" ]; then
    ES_YML_FILE=docker-compose_dev.yml
fi

function join_by() {
    local IFS="$1"
    shift
    echo "$*"
}

function create_proxy_env_file() {

    if [ -f "$PROXY_ENV_FILE" ]; then
        return
    fi

    touch "$PROXY_ENV_FILE"

    # Skip copying configurations whith nameservers pointing to 127.*.*.*
    if grep -E '^\s*nameserver\s+127\.[0-9]+\.[0-9]+\.[0-9]+.*' "$RESOLV_FILE"; then
        return
    fi

    NAMESERVERS=$(grep -oP '^\s*nameserver\s+\K.*' "$RESOLV_FILE")
    SEARCH_DOMAINS=$(grep -oP '^\s*search\s+\K.*' "$RESOLV_FILE")

    if [ ! -z "${NAMESERVERS}" ]; then
        (
            cat <<EOF
PROXY_NAMESERVERS=$(join_by , ${NAMESERVERS})
EOF
        ) >>"$PROXY_ENV_FILE"
    fi

    if [ ! -z "${SEARCH_DOMAINS}" ]; then
        (
            cat <<EOF
DNSMASQ_ENABLE_SEARCH=True
DNSMASQ_SEARCH_DOMAINS=$(join_by , ${SEARCH_DOMAINS})
EOF
        ) >>"$PROXY_ENV_FILE"
    fi
}

function test_swarm_exists() {
    echo $(docker info | grep -i 'swarm: active')
}

function init_swarm() {
    if [ -z "$IP_ADDRESS" ]; then
        result=$( (docker swarm init --advertise-addr $NETWORK_INTERFACE --task-history-limit 0) 2>&1)
    else
        result=$( (docker swarm init --advertise-addr $IP_ADDRESS --task-history-limit 0) 2>&1)
    fi

    if [[ $result =~ 'already part' ]]; then
        echo 2
    elif [[ $result =~ 'Error' ]]; then
        echo 11
    else
        echo 0
    fi
}

function set_experimental() {
    if [ -f /etc/docker/daemon.json ] && [ $(grep -c '"experimental" : true' /etc/docker/daemon.json) -eq 1 ]; then
        echo '"experimental" : true in /etc/docker/daemon.json'
    else
        echo $'{\n\"experimental\" : true\n}\n' >/etc/docker/daemon.json
        echo 'Setting: "experimental" : true in /etc/docker/daemon.json'
    fi
}

function create_uuid() {
    if [ $(docker secret ls | grep -c $SECRET_UID) -eq 0 ]; then
        uuid=$(uuidgen)
        uuid=${uuid^^}
        echo $uuid | docker secret create $SECRET_UID -
        echo "$SECRET_UID created: uuid: $uuid "
    else
        echo " $SECRET_UID secret already exist "
    fi
}

function pull_images() {
    filename=./shield-version.txt
    LINE=0
    while read -r line; do
        if [ "${line:0:1}" == '#' ]; then
            echo "$line"
        else
            arr=($line)
            if [ $LINE -eq 1 ]; then
                if [ $(grep -c ${arr[1]} .version) -gt 1 ]; then
                    echo "No new version detected"
                    break
                fi
            else
                echo "################## Pulling images  ######################"
                echo "pulling image: ${arr[1]}"
                docker pull "securebrowsing/${arr[1]}"
            fi
        fi
        LINE=$((LINE + 1))
    done <"$filename"
}

function get_right_interface() {
    TEST_MAC=$(uname | grep Linux)
    if [ ! "$TEST_MAC" ]; then
        echo $(ifconfig $(netstat -rn | grep -E "^default|^0.0.0.0" | head -1 | awk '{print $NF}') | grep 'inet ' | awk '{print $2}' | grep -Eo '([0-9]*\.){3}[0-9]*')
    else
        echo $(route | grep '^default' | grep -o '[^ ]*$')
    fi
}

function make_in_memory_volume() {
    if [ ! -d "/media/containershm" ]; then
        mkdir -p /media/containershm
        mount -t tmpfs -o size=2G tmpfs /media/containershm
        echo 'tmpfs   /media/containershm     tmpfs   rw,size=2G      0       0' >>/etc/fstab
    fi
}

function replace_syslog_host_address() {
    echo "Setting syslog server address to $1 in $2 ..."
    sed -i -r -e "s/(^\s*syslog-address:)(.*):5014/\1 $1/" "$2"
    echo "... done updating $2"
}

while [ "$1" != "" ]; do
    case $1 in
    -s | --single-mode)
        SINGLE_MODE=true
        ;;
    esac
    shift
done

if [ -z "$SINGLE_MODE" ]; then
    echo 'Run multinode script'
    exit 0
else
    SWARM=$(test_swarm_exists)
    if [ -z "$SWARM" ]; then
        echo '#######################Start create swarm#####################'
        if [ -z "$IP_ADDRESS" ]; then
            NETWORK_INTERFACE=$(get_right_interface)
            for int in $NETWORK_INTERFACE; do
                NETWORK_INTERFACE=$int
                break
            done
        fi
        SWARM_RESULT=$(init_swarm)
        if [ "$SWARM_RESULT" != "0" ]; then
            echo "Swarm init failed"
            exit 1
        fi
        echo '########################Swarm created########################'
    fi
fi

create_uuid
make_in_memory_volume
set_experimental

SYS_LOG_HOST=$(docker node ls | grep Leader | awk '{print $3}')
SYSLOG_ADDRESS="udp:\/\/$SYS_LOG_HOST:5014"
replace_syslog_host_address "$SYSLOG_ADDRESS" "$ES_YML_FILE"
create_proxy_env_file

pull_images

docker node update --label-add browser=yes --label-add shield_core=yes --label-add management=yes $SYS_LOG_HOST

docker stack deploy -c $ES_YML_FILE $STACK_NAME --with-registry-auth
