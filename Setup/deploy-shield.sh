#!/bin/bash

#set -x
############################################
#####   Ericom Shield Startup Script   #####
###################################LO##BH###
JENKINS=
NETWORK_INTERFACE='eth0'
STACK_NAME='shield'
HOST="$(hostname)"
SECRET_UID="shield-system-id"
ES_NO_BROWSERS_LABEL='false'

export UPSTREAM_DNS_SERVERS="$(grep -oP 'nameserver\s+\K.+' /etc/resolv.conf | cut -d, -f2- | paste -sd,)"
PROXY_ENV_FILE="proxy-server.env"
ES_PATH="/usr/local/ericomshield"
CONSUL_BACKUP_PATH="$ES_PATH/backup"
DOCKER_SWARMEXEC_TAG=180128-09.08-1217
ES_YML_FILE="$ES_PATH/docker-compose.yml"
EULA_ACCEPTED_FILE="$ES_PATH/.eula_accepted"
ES_MY_IP_FILE="$ES_PATH/.es_ip_address"

########################################################################################################################
########   Default deploy variables section                                       ######################################
##########################################################################################################LO############
export SUB_NET="10.20.0.0/16"
export SHIELD_PROXY_PORT="3128"

if [ -f "$ES_PATH/customer.env" ]; then
    source "$ES_PATH/customer.env"
fi
########################################################################################################################
###########################   End default section                                                  #####################
########################################################################################################################

if [ ! -d "$CONSUL_BACKUP_PATH" ]; then
    mkdir -p "$CONSUL_BACKUP_PATH"
fi

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -no-browser)
        ES_NO_BROWSERS_LABEL='true'
        echo "Multi-Machine: No Browser Label"
        ;;
    #        -usage)
    -j | --jenkins)
        JENKINS="yes"
        ;;
    *)
        echo "Usage: $0 [-no-browser]"
        exit
        ;;
    esac
    shift
done

if [ -z "$JENKINS" ]; then
    if [ ! -f "$EULA_ACCEPTED_FILE" ] || [ ! -f "$ES_MY_IP_FILE" ]; then
        echo "Ericom Shield has not been configured properly. Please run '$ES_PATH/setup.sh'. Exiting..."
        exit 1
    else
        IP_ADDRESS="$(cat "$ES_MY_IP_FILE" | grep -oP '\d+\.\d+\.\d+\.\d+')"
    fi

    if ! systemctl start docker; then
        echo "Could not start Docker. Exiting..."
        exit 1
    fi
fi

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

ES_YML_FILE=docker-compose.yml

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
    if [ "$ES_NO_BROWSERS_LABEL" == true ]; then
        echo "***************     Adding Labels: management, shield_core"
        retry_on_failure docker node update --label-add shield_core=yes --label-add management=yes $LEADER_HOST
    else
        echo "***************     Adding Labels: management, shield_core, browser"
        retry_on_failure docker node update --label-add browser=yes --label-add shield_core=yes --label-add management=yes $LEADER_HOST
    fi
fi

# am_i_leader # Allow to run Deploy on any manager

#if [ "$AM_I_LEADER" == true ]; then
    retry_on_failure docker stack deploy -c $ES_YML_FILE $STACK_NAME --with-registry-auth
#else
#    echo "Please run this command on the leader: $LEADER_HOST"
#fi
