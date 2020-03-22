#!/bin/bash
############################################
#####   Ericom Shield: Rancher CLI Install #
#######################################BH###

NOT_FOUND_STR="404: Not Found"
STEP_BY_STEP="false"
ES_PATH="$HOME/ericomshield"
LOGFILE="$ES_PATH/ericomshield.log"
RANCHER_CLI="false"
RANCHER_CLI_VERSION="v2.3.2"
ES_repo_rancher_cli="https://github.com/rancher/cli/releases/download/$RANCHER_CLI_VERSION/rancher-linux-amd64-$RANCHER_CLI_VERSION.tar.xz"
ES_file_rancher_cli="rancher-linux-amd64-$RANCHER_CLI_VERSION.tar.xz"
ES_file_cluster_config="cluster.json"

RANCHER_URL_FILE="$ES_PATH/.esrancherurl"
RANCHER_TOKEN_FILE="$ES_PATH/.esranchertoken"
CLUSTER_NAME="shield-cluster"
CLUSTER_CREATED="false"   # Flag for Cluster Creation
ES_CLUSTER_MIN="false"    # If true use Minimum Node Allocation for K8s
RANCHER_API_TOKEN="NDY"
RANCHER_SERVER_URL="NDY"
LOCAL_RANCHER_SERVER_URL="https://127.0.0.1:8443"

function usage() {
     echo " Usage: $0 [-h|--help]"
}

#Check if we are root
if ((EUID != 0)); then
    # sudo su
    usage
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

function log_message() {
    local PREV_RET_CODE=$?
    echo "$@"
    echo "$(LC_ALL=C date): $@" >>"$LOGFILE"
    if ((PREV_RET_CODE != 0)); then
        return 1
    fi
    return 0
}

function get_outgoing_ip() {
    local ADDR=$(echo $1 | grep -oP '.*://\K([0-9\.]*)') #'
    if [ -z $ADDR ]; then
        ADDR=$1
    fi
    ip route get $ADDR | awk -F"src " 'NR==1{split($2,a," ");print a[1]}'
}

function get_my_ip() {
    local MY_IP="$(get_outgoing_ip 8.8.8.8)"
    if [ -z $MY_IP ]; then
        MY_IP="$(get_outgoing_ip $HTTP_PROXY)"
    fi
    if [ -z $MY_IP ]; then
        MY_IP="$(get_outgoing_ip $http_proxy)"
    fi
    echo $MY_IP
}

log_message $(get_my_ip)

export no_proxy="localhost,127.0.0.1,0.0.0.0,$(get_my_ip),$no_proxy"

function step() {
    if [ $STEP_BY_STEP = "true" ]; then
        read -p 'Press Enter to continue...' ENTER
    fi
}

function install_if_not_installed() {
    if ! dpkg -s "$1" >/dev/null 2>&1; then
        echo "***************     Installing $1"
        apt-get --assume-yes -y install "$1"
    fi
}

function install_rancher_cli() {
    if ! which rancher >/dev/null; then
        pushd "$(mktemp -d)"
        wget "$ES_repo_rancher_cli"
        tar xf "$ES_file_rancher_cli"
        mv rancher-*/rancher /usr/bin/
        rm -rf rancher-*
        popd
    fi
}

# Generate Rancher Token (Thx to Erez)
function generate_rancher_token() {
    #read es_rancher files

    if [ -f $RANCHER_URL_FILE ]; then
       RANCHER_SERVER_URL=$(cat $RANCHER_URL_FILE)
       echo "Found $RANCHER_URL_FILE: $RANCHER_SERVER_URL"
    fi

    if [ -f $RANCHER_TOKEN_FILE ]; then
       RANCHER_API_TOKEN=$(cat $RANCHER_TOKEN_FILE)
       echo "Found $RANCHER_TOKEN_FILE: $RANCHER_API_TOKEN"       
    fi

    # Login token good for 1 minute
    LOGINTOKEN=$(curl -k -s 'https://127.0.0.1:8443/v3-public/localProviders/local?action=login' -H 'content-type: application/json' --data-binary '{"username":"admin","password":"admin","ttl":60000}' | jq -r .token)
    if [ "$LOGINTOKEN" = null ]; then
        LOGINTOKEN=$(curl -k -s 'https://127.0.0.1:8443/v3-public/localProviders/local?action=login' -H 'content-type: application/json' --data-binary '{"username":"admin","password":"ericomshield","ttl":60000}' | jq -r .token)
    else
        # Change password
        curl -k -s 'https://127.0.0.1:8443/v3/users?action=changepassword' -H 'Content-Type: application/json' -H "Authorization: Bearer $LOGINTOKEN" --data-binary '{"currentPassword":"admin","newPassword":"ericomshield"}'
    fi
    echo "LOGINTOKEN=$LOGINTOKEN"
    if [ "$LOGINTOKEN" = null ]; then
        return 1
    fi
    # Create API Token good forever
    RANCHER_API_TOKEN=$(curl -k -s 'https://127.0.0.1:8443/v3/token' -H 'Content-Type: application/json' -H "Authorization: Bearer $LOGINTOKEN" --data-binary '{"type":"token","description":"for shield installations"}' | jq -r .token)
    echo "API Token: ${RANCHER_API_TOKEN}"
    echo $RANCHER_API_TOKEN >$RANCHER_TOKEN_FILE
    # Set server-url
    echo "SERVER_URL=$RANCHER_SERVER_URL"
    SERVER_URL_JSN="{\"name\":\"server-url\",\"value\":\"${RANCHER_SERVER_URL}\"}"
    echo $SERVER_URL_JSN
    curl -k 'https://127.0.0.1:8443/v3/settings/server-url' -H 'Content-Type: application/json' -H "Authorization: Bearer $RANCHER_API_TOKEN" -X PUT --data-binary "$SERVER_URL_JSN"
    return 0
}

# Wait until Rancher is launched
function wait_for_rancher() {
    #read es_rancher files
    if [ -f $RANCHER_URL_FILE ]; then
       RANCHER_SERVER_URL=$(cat $RANCHER_URL_FILE)
       echo "Found $RANCHER_URL_FILE: $RANCHER_SERVER_URL"
    else
       RANCHER_SERVER_URL="https://$(get_my_ip):8443"
       echo $RANCHER_SERVER_URL >$RANCHER_URL_FILE
    fi
    log_message "Waiting for Rancher: ${RANCHER_SERVER_URL}"
    RANCHER_PONG="NDY"
    wait_count=0
    while [ ! "$RANCHER_PONG" = "pong" ] && ((wait_count < 20)); do
        echo -n "."
        sleep 3
        wait_count=$((wait_count + 1))
        RANCHER_PONG=$(curl -k "${RANCHER_SERVER_URL}/ping")
        if [ ! $RANCHER_PONG = "" ]; then
          echo "$RANCHER_PONG"
        fi  
    done
    if [ ! "$RANCHER_PONG" = "pong" ]; then
        echo bug
        log_message "Error: Cannot Connect to Rancher on: ${RANCHER_SERVER_URL}"
        exit 1
    else
        echo "ok!"
        return 0
    fi
}

function wait_for_rancher_cluster() {
    # Wait until Cluster is active
    log_message "Waiting for Shield Cluster state to become active ."
    CLUSTER_STATE=0
    wait_count=0
    while [ "$CLUSTER_STATE" -lt 1 ] && ((wait_count < 60)); do
        echo -n .
        sleep 10
        wait_count=$((wait_count + 1))
        CLUSTER_STATE=$(rancher cluster shield-cluster | grep -c -w active)
    done
    if [ "$CLUSTER_STATE" -lt 1 ]; then
        echo
        log_message "Error: Shield Cluster is not active, please check on Rancher UI."
        exit 1
    fi
    echo "ok!"
    return 0
}

# Create Cluster (Thx to Andrei)
function create_rancher_cluster() {

    if [ -z $RANCHER_API_TOKEN ]; then
        # Read the API details
        echo "It didnt work, please Create Rancher Token from UI"
        read -p 'Enter server URL https://<SERVER_URL>: ' LOCAL_RANCHER_SERVER_URL
        read -p 'Enter server BEARER TOKEN: ' RANCHER_API_TOKEN
    fi

    echo "Rancher login:"
    rancher login --token $RANCHER_API_TOKEN --skip-verify $LOCAL_RANCHER_SERVER_URL
    sleep 5
    echo "Creating the Cluster:"
    rancher cluster create --network-provider flannel --rke-config $ES_PATH/$ES_file_cluster_config $CLUSTER_NAME
    rancher context switch
    echo "Rancher login (again):"
    rancher login --token $RANCHER_API_TOKEN --skip-verify $LOCAL_RANCHER_SERVER_URL
    CLUSTER_CREATED="true"
    sleep 5
    echo "Registering node:"
    ADD_NODE_CMD=$(rancher cluster add-node $CLUSTER_NAME | grep docker)
    ROLES_CMD=" --etcd --controlplane --worker"

    if [ -z "${ADD_NODE_CMD}" ]; then
        return 1
    else
        eval $ADD_NODE_CMD$ROLES_CMD
    fi

    wait_for_rancher_cluster

    rancher cluster kf $CLUSTER_NAME >~/.kube/config

    return 0
}

function move_namespaces() {
    # Create (if not exist) and moving Namespaces
    if [ $(kubectl get namespace | grep elk | grep -c Active) -le 0 ]; then
        kubectl create namespace elk
    fi
    rancher namespaces move elk Default
    if [ $(kubectl get namespace | grep farm-services | grep -c Active) -le 0 ]; then
        kubectl create namespace farm-services
    fi
    rancher namespaces move farm-services Default
    if [ $(kubectl get namespace | grep management | grep -c Active) -le 0 ]; then
        kubectl create namespace management
    fi
    rancher namespaces move management Default
    if [ $(kubectl get namespace | grep proxy | grep -c Active) -le 0 ]; then
        kubectl create namespace proxy
    fi
    rancher namespaces move proxy Default
    if [ $(kubectl get namespace | grep common | grep -c Active) -le 0 ]; then
        kubectl create namespace common
    fi
    rancher namespaces move common Default
}

##################      MAIN: EVERYTHING STARTS HERE: ##########################
log_message "***************     Ericom Shield Rancher CLI ..."

install_if_not_installed jq

install_rancher_cli

step

wait_for_rancher

step

generate_rancher_token

step

create_rancher_cluster

if [ $? = 0 ]; then
   step
   move_namespaces
fi

log_message "***************     Done !!!"