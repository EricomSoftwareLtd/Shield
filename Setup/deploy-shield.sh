#!/bin/bash

#set -x

###########################################
#####   Ericom Shield Installer        #####
###################################LO##BH###
JENKINS=
NETWORK_INTERFACE='eth0'
STACK_NAME='shield'
ES_YML_FILE=
HOST=$(hostname)
SECRET_UID="shield-system-id"

RESOLV_FILE="/etc/resolv.conf"
PROXY_ENV_FILE="proxy-server.env"
ES_PATH=/usr/local/ericomshield
CONSUL_BACKUP_PATH="$ES_PATH/backup"
DOCKER_SWARMEXEC_TAG=180128-09.08-1217

if [ ! -d "$CONSUL_BACKUP_PATH" ]; then
    mkdir -p "$CONSUL_BACKUP_PATH"
fi

#For bckwrd-compatibility and Jenkins
if [ ! -f "$ES_YML_FILE" ]; then
    ES_YML_FILE=docker-compose_dev.yml
fi

function join_by() {
    local IFS="$1"
    shift
    echo "$*"
}

function retry_on_failure() {
    local n=1
    local max=5
    local delay=10
    while true; do
        "$@" && break || {
            if [[ $n -lt $max ]]; then
                ((n++))
                echo "The command '$@' failed. Attempt $n/$max:"
                sleep $delay
            else
                echo "The command '$@' has failed after $n attempts." >&2
                echo "Please try to execute ./stop.sh then ./run.sh commands" >&2
                exit 1
            fi
        }
    done
}

function create_proxy_env_file() {
    if [ -f "$PROXY_ENV_FILE" ]; then
        return
    fi

    touch "$PROXY_ENV_FILE"
}

function test_swarm_exists() {
    echo $(docker info | grep -i 'swarm: active')
}

function init_swarm() {
    if [ -z "$IP_ADDRESS" ]; then
        result=$( (retry_on_failure docker swarm init --advertise-addr $NETWORK_INTERFACE --task-history-limit 0) 2>&1)
    else
        result=$( (retry_on_failure docker swarm init --advertise-addr $IP_ADDRESS --task-history-limit 0) 2>&1)
    fi

    if [[ $result =~ 'already part' ]]; then
        echo 2
    elif [[ $result =~ 'Error' ]]; then
        echo 11
    else
        echo 0
    fi
}

function am_i_leader() {
    if [ -z "$JENKINS" ]; then
        AM_I_LEADER=$(docker node inspect $(hostname) --format "{{ .ManagerStatus.Leader }}" | grep "true")
    else
        AM_I_LEADER=true
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

while [ "$1" != "" ]; do
    case $1 in
    -j | --jenkins)
        JENKINS="yes"
        ;;
    esac
    shift
done

if [ -z "$JENKINS" ]; then
    ES_YML_FILE=docker-compose.yml
else
    ES_YML_FILE=docker-compose_dev.yml
fi

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

create_uuid
make_in_memory_volume

LEADER_HOST=$(docker node ls | grep Leader | awk '{print $3}')
# ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS
# id123 *   shield-mng1         Ready               Active              Leader  # when leader is current node hostname is 3rd param (ID, *, hostname)
# id123    shield-mng1         Ready               Active              Leader   # when leader is not current node hostname is the 2nd param (ID, hostname)
if [ $LEADER_HOST == "Ready" ]; then
    LEADER_HOST=$(docker node ls | grep Leader | awk '{print $2}')
fi
create_proxy_env_file

NODES_COUNT=$(docker node ls | grep -c Ready)
if [ "$NODES_COUNT" -eq 1 ]; then
    echo "***************     Adding Labels:browser, shield_core, management"
    retry_on_failure docker node update --label-add browser=yes --label-add shield_core=yes --label-add management=yes $LEADER_HOST
fi

am_i_leader

if [ "$AM_I_LEADER" == true ]; then
    if [ -z "$JENKINS" ]; then
        # Copy docker-compose.yml across all manager nodes
        echo "Copy docker-compose.yml across all manager nodes"
        docker service rm copy_yaml 2>/dev/null || true
        docker config rm yaml 2>/dev/null || true
        docker pull "securebrowsing/shield_swarm-exec:$DOCKER_SWARMEXEC_TAG"
        docker config create yaml "/usr/local/ericomshield/$ES_YML_FILE"
        docker service create --constraint "node.labels.management==yes" --name copy_yaml --mode=global --restart-condition none \
            --with-registry-auth \
            --mount "type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock" \
            --mount "type=bind,source=/usr/local/ericomshield,target=/mnt" \
            --config src=yaml,target="/tmp/$ES_YML_FILE" \
            "securebrowsing/shield_swarm-exec:$DOCKER_SWARMEXEC_TAG" \
            /bin/sh -c "cp -f /tmp/$ES_YML_FILE /mnt/$ES_YML_FILE && sleep 50"
        docker service rm copy_yaml
        docker config rm yaml
    fi
    retry_on_failure docker stack deploy -c $ES_YML_FILE $STACK_NAME --with-registry-auth
else
    echo "Please run this command on the leader: $LEADER_HOST"
fi
