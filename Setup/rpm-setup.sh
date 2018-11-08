#!/bin/bash
############################################
#####   Ericom Shield Setup Script     #####
#######################################BH###

function usage() {
    echo " Usage: $0 [-f|--force] [--autoupdate] [--quickeval] [--registry] <registry-ip:port> [--help]"
}

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    usage
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

ES_PATH="/usr/local/ericomshield"
ES_VER_FILE="$ES_PATH/shield-version.txt"
ES_VER_FILE_BAK="${ES_VER_FILE}.rpmsave"
LOGFILE="$ES_PATH/ericomshield.log"
UPDATE=false
UPDATE_NEED_RESTART=false
ES_AUTO_UPDATE_FILE="$ES_PATH/.autoupdate"
EULA_ACCEPTED_FILE="$ES_PATH/.eula_accepted"
ES_MY_IP_FILE="$ES_PATH/.es_ip_address"
ES_SHIELD_REGISTRY_FILE="$ES_PATH/.es_registry"
SUCCESS=false

#SHIELD_REGISTRY="127.0.0.1:5000"
SHIELD_REGISTRY=""
DOCKER_USER="ericomshield1"
DOCKER_SECRET="Ericom98765$"
ES_AUTO_UPDATE=false
ES_FORCE=false
ES_FORCE_SET_IP_ADDRESS=false
ES_RUN_DEPLOY=true
SWITCHED_TO_MULTINODE=false

function log_message() {
    local PREV_RET_CODE=$?
    echo "$@"
    echo "$(LC_ALL=C date): $@" >>"$LOGFILE"
    if ((PREV_RET_CODE != 0)); then
        return 1
    fi
    return 0
}

cd "$ES_PATH" || exit

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    --autoupdate)
        ES_AUTO_UPDATE=true
        ;;
    -f | --force)
        ES_FORCE=true
        if [ -f "$ES_VER_FILE" ]; then
            echo " " >$ES_VER_FILE
        fi
        ;;
    --force-ip-address-selection)
        ES_FORCE_SET_IP_ADDRESS=true
        ;;
    --restart)
        UPDATE_NEED_RESTART=true
        echo " Restart will be done during upgrade "
        ;;
    --approve-eula)
        log_message "EULA has been accepted from Command Line"
        date -Iminutes >"$EULA_ACCEPTED_FILE"
        ;;
    --no-deploy)
        ES_RUN_DEPLOY=false
        echo "Setup Only (No Deploy) "
        ;;
    --registry)
        shift
        SHIELD_REGISTRY="$1"
        echo $SHIELD_REGISTRY >"$ES_SHIELD_REGISTRY_FILE"
        ;;
    *)
        usage
        exit
        ;;
    esac
    shift
done

if [ -f "$ES_SHIELD_REGISTRY_FILE" ]; then
    SHIELD_REGISTRY="$(cat "$ES_SHIELD_REGISTRY_FILE")"
fi

if [ "$ES_AUTO_UPDATE" == true ]; then
    echo "ES_AUTO_UPDATE" >"$ES_AUTO_UPDATE_FILE"
fi

function save_my_ip() {
    echo "$MY_IP" >"$ES_MY_IP_FILE"
}

function restore_my_ip() {
    if [ -s "$ES_MY_IP_FILE" ]; then
        MY_IP="$(cat "$ES_MY_IP_FILE" | grep -oP '\d+\.\d+\.\d+\.\d+')"
        if [[ -z $MY_IP ]]; then
            return 1
        else
            return 0
        fi
    fi
    return 1
}

function choose_network_interface() {

    local INTERFACES=($(find /sys/class/net -type l -not -lname '*virtual*' -printf '%f\n'))
    local INTERFACE_ADDRESSES=()
    local OPTIONS=()

    for IFACE in "${INTERFACES[@]}"; do
        OPTIONS+=("Name: \"$IFACE\", IP address: $(/sbin/ip address show scope global dev $IFACE | grep -oP '(?<=inet )\d+\.\d+\.\d+\.\d+')")
        INTERFACE_ADDRESSES+=("$(/sbin/ip address show scope global dev $IFACE | grep -oP '(?<=inet )\d+\.\d+\.\d+\.\d+')")
    done

    if ((${#OPTIONS[@]} == 0)); then
        log_message "No network interface cards detected. Aborting!"
        exit 1
    elif ((${#OPTIONS[@]} == 1)); then
        local REPLY=1
        log_message "Using ${INTERFACES[$((REPLY - 1))]} with address ${INTERFACE_ADDRESSES[$((REPLY - 1))]} as an interface for Shield"
        MY_IP="${INTERFACE_ADDRESSES[$((REPLY - 1))]}"
        return
    fi

    echo "Choose a network card to be used by Shield"
    PS3="Enter your choice: "
    select opt in "${OPTIONS[@]}" "Quit"; do

        case "$REPLY" in

        [1-$((${#OPTIONS[@]}))]*)
            log_message "Using ${INTERFACES[$((REPLY - 1))]} with address ${INTERFACE_ADDRESSES[$((REPLY - 1))]} as an interface for Shield"
            MY_IP="${INTERFACE_ADDRESSES[$((REPLY - 1))]}"
            return
            ;;
        $((${#OPTIONS[@]} + 1)))
            break
            ;;
        *)
            echo "Invalid option. Try another one."
            continue
            ;;
        esac
    done

    failed_to_setup "Aborting setup!"
}

function failed_to_setup() {
    log_message "An error occurred during the setup process: $1, Exiting!"
    exit 1
}

function failed_to_setup_cleaner() {
    log_message "An error occurred during the setup process: $1, Exiting!"
    if [ "$UPDATE" == true ]; then
        if [ -f "$ES_VER_FILE" ]; then
            mv "$ES_VER_FILE_BAK" "$ES_VER_FILE"
        fi
    else
        if [ -f "$ES_VER_FILE" ]; then
            rm -f "$ES_VER_FILE"
        fi
    fi
    exit 1
}

function accept_license() {
    export LESSSECURE=1
    while LC_ALL="en_US.UTF-8" less -P"%pb\% Press h for help or q to quit" "$1" &&
        read -p "Do you accept the EULA (yes/no/anything else to display it again)? " choice; do
        case "$choice" in
        y | Y | n | N)
            echo 'Please, type "yes" or "no"'
            read -n1 -r -p "Press any key to continue..." key
            ;;
        "yes" | "YES" | "Yes")
            echo "yes"
            return 0
            ;;
        "no" | "NO" | "No")
            echo "no"
            break
            ;;
        *) ;;

        esac
    done

    return -1
}

function docker_login() {
    if [ "$(docker info | grep -c Username)" -eq 0 ]; then
        if [ "$DOCKER_USER" == " " ]; then
            echo " Please enter your login credentials to docker-hub"
            docker login
        else
            #Login and enter the credentials you received separately when prompt
            echo "docker login" $DOCKER_USER $DOCKER_SECRET
            echo "$DOCKER_SECRET" | docker login --username=$DOCKER_USER --password-stdin
        fi

        if [ $? == 0 ]; then
            echo "Login Succeeded!"
        else
            failed_to_setup_cleaner "Cannot Login to docker, Exiting!"
        fi
    fi
}

function prepare_yml() {
    #echo "  sed -i'' 's/IP_ADDRESS/$MY_IP/g' $ES_YML_FILE"
    sed -i'' "s/IP_ADDRESS/$MY_IP/g" $ES_YML_FILE

    local TZ="$(date '+%Z')"
    sed -i'' "s#TZ=UTC#TZ=${TZ}#g" $ES_YML_FILE
}

function switch_to_multi_node() {
    if [ $(grep -c '#[[:space:]]*mode: global[[:space:]]*#multi node' $ES_YML_FILE) -eq 1 ]; then
        echo "Switching to Multi-Node (consul-server -> global)"
        sed -i'' 's/\(mode: replicated[[:space:]]*#single node\)/#\1/g' $ES_YML_FILE
        sed -i'' 's/\(replicas: 5[[:space:]]*#single node\)/#\1/g' $ES_YML_FILE
        sed -i'' 's/#\([[:space:]]*mode: global[[:space:]]*#multi node\)/\1/g' $ES_YML_FILE
        SWITCHED_TO_MULTINODE=true
    fi
}

function pull_images() {
    if [ -f "$ES_VER_FILE_BAK" ] && [ "$(diff "$ES_VER_FILE" "$ES_VER_FILE_BAK" | wc -l)" -eq 0 ]; then
        echo "No new version detected"
        return
    fi
    LINE=0
    while read -r line; do
        if [ "${line:0:1}" == '#' ]; then
            echo "$line"
        else
            arr=($line)
            if [ $LINE -ge 3 ]; then
                echo "################## Pulling images  ######################"
                echo "pulling image: ${arr[1]} ($SHIELD_REGISTRY)"
                if [ ! -z "$SHIELD_REGISTRY" ]; then
                    IMAGE_NAME="$SHIELD_REGISTRY/securebrowsing/${arr[1]}"
                else
                    docker pull "securebrowsing/${arr[1]}"
                fi
            fi
        fi
        LINE=$((LINE + 1))
    done <"$ES_VER_FILE"
}

function count_running_docker_services() {
    services=($(docker service ls --format "{{.Replicas}}" | awk 'BEGIN {FS = "/"; sum=0}; {d=$2-$1; sum+=d>0?d:-d} END {print sum}'))

    if ! [[ $? ]]; then
        log_message "Could not list services. Is Docker running?"
        return 1
    fi
    return 0
}

function wait_for_docker_to_settle() {
    local wait_count=0
    count_running_docker_services
    while ((services != 0)) && ((wait_count < 12)); do
        if [ $wait_count == 0 ]; then
            log_message "Not all services have reached their target scale. Waiting for Docker to settle..."
        fi

        echo -n .
        sleep 10
        wait_count=$((wait_count + 1))
        count_running_docker_services
    done
}

function test_swarm_exists() {
    echo $(docker info | grep -i 'swarm: active')
}

function am_i_leader() {
    AM_I_LEADER=$(docker node inspect $(hostname) --format "{{ .ManagerStatus.Leader }}" | grep "true")
}

function check_registry() {
    if [ ! -z $SHIELD_REGISTRY ]; then
        log_message "Testing the registry..."
        if ! docker run --rm "$SHIELD_REGISTRY/alpine:latest" "/bin/true"; then
            log_message "Registry test failed"
            return 1
        else
            log_message "Registry test OK"
        fi
    fi

    return 0
}

function update_daemon_json() {
    if [ ! -z $SHIELD_REGISTRY ]; then
        if [ -f "/etc/docker/daemon.json" ] && [ "$(jq --compact-output '."insecure-registries"' "/etc/docker/daemon.json")" == "[$SHIELD_REGISTRY]" ]; then
            echo '/etc/docker/daemon.json is ok'
        else
            (test -f /etc/docker/daemon.json && cat /etc/docker/daemon.json || echo "{}") |
                jq ". += {\"insecure-registries\": [$SHIELD_REGISTRY]}" >/etc/docker/daemon.json.shield
            mv /etc/docker/daemon.json.shield /etc/docker/daemon.json
            systemctl reload docker
        fi
    fi
}

##################      MAIN: EVERYTHING STARTS HERE: ##########################

if [ "$UPDATE" == false ] && [ ! -f "$EULA_ACCEPTED_FILE" ] && [ "$ES_RUN_DEPLOY" == true ]; then
    echo 'You will now be presented with the End User License Agreement.'
    echo 'Use PgUp/PgDn/Arrow keys for navigation, q to exit.'
    echo 'Please, read the EULA carefully, then accept it to continue the setup process or reject to exit.'
    read -n1 -r -p "Press any key to continue..." key
    echo

    if accept_license "$ES_PATH/Ericom-EULA.txt"; then
        log_message "EULA has been accepted"
        date -Iminutes >"$EULA_ACCEPTED_FILE"
    else
        failed_to_setup_cleaner "EULA has not been accepted, exiting..."
    fi
fi

if [ "$ES_RUN_DEPLOY" == true ]; then
    if ! restore_my_ip || [[ $ES_FORCE_SET_IP_ADDRESS == true ]]; then
        choose_network_interface
    fi
    save_my_ip
fi

echo Docker Login: $DOCKER_USER
echo "autoupdate=$ES_AUTO_UPDATE"

update_daemon_json

if systemctl start docker; then
    echo "Starting docker service ***************     Success!"
else
    failed_to_setup "Failed to start docker service"
fi

docker_login

if ! check_registry; then
    log_message "Using Docker Hub instead of local registry at $SHIELD_REGISTRY"
    SHIELD_REGISTRY=""
    while read -p "Do you want to proceed (Yes/No)? " choice; do
        case "$choice" in
        y | Y | "yes" | "YES" | "Yes")
            echo "yes"
            break
            ;;
        n | N | "no" | "NO" | "No")
            echo "no"
            echo "Exiting..."
            exit 10
            ;;
        *) ;;

        esac
    done
fi

prepare_yml

if [ "$UPDATE" == false ]; then
    AM_I_LEADER=true   #if new installation, i am the leader
    # New Installation
    echo "pull images" #before starting the system
    pull_images

else # Update
    STOP_SHIELD=false
    SWARM=$(test_swarm_exists)
    if [ ! -z "$SWARM" ]; then
        am_i_leader
        MNG_NODES_COUNT=$(docker node ls -f "role=manager" | grep -c Ready)
        CONSUL_GLOBAL=$(docker service ls | grep -c "consul-server    global")
        if [ "$MNG_NODES_COUNT" -gt 1 ]; then
            switch_to_multi_node
            if [ "$CONSUL_GLOBAL" -ne 1 ]; then
                if [ "$AM_I_LEADER" == true ]; then
                    STOP_SHIELD=true
                fi
            fi
        fi
    else
        AM_I_LEADER=true #if swarm doesnt exist i am the leader
    fi

    echo "pull images" #before restarting the system for upgrade
    pull_images

    if [ "$AM_I_LEADER" == "true" ]; then
        if [ "$ES_RUN_DEPLOY" == "true" ]; then
            if [ "$UPDATE_NEED_RESTART" == "true" ] || [ "$STOP_SHIELD" == "true" ]; then
                log_message "Stopping Ericom Shield for Update (Downtime)"
                ./stop.sh
            else
                if [ ! -z "$SWARM" ]; then
                    echo -n "stop shield-broker"
                    docker service scale shield_broker-server=0
                    wait_for_docker_to_settle
                fi
            fi
        fi
    fi
fi

if [ -n "$MY_IP" ]; then
    echo "Connect swarm to $MY_IP"
    export IP_ADDRESS="$MY_IP"
fi

if [ "$ES_RUN_DEPLOY" == true ] && [ "$AM_I_LEADER" == true ]; then
    echo "source deploy-shield.sh"
    source deploy-shield.sh

    # Check the result of the last command (start, status, deploy-shield)
    if [ $? == 0 ]; then
        echo "***************     Success!"

        #Check the status of the system wait 20*10 (~3 mins)
        wait=0
        while [ $wait -lt 10 ]; do
            if "$ES_PATH"/status.sh; then
                echo "Ericom Shield is Running!"
                SUCCESS=true
                break
            else
                echo -n .
                sleep 30
            fi
            wait=$((wait + 1))
        done
    else
        failed_to_setup_cleaner "Deploy Failed"
    fi
else
    echo "Setup only (no deployment or not the leader)"
    SUCCESS=true
fi

systemctl start ericomshield-updater.service

Version=$(grep SHIELD_VER "$ES_YML_FILE")

if [ $SUCCESS == false ]; then
    echo "Something went wrong. Timeout was reached during setup. Please run ./status.sh and check the log file: $LOGFILE."
    echo "$(date): Timeout was reached during the setup" >>"$LOGFILE"
    exit 1
fi

if [ "$SWITCHED_TO_MULTINODE" == "true" ]; then
    echo "Run consul data restore according switching consul mode"
    ./restore.sh
fi

echo "***************     Success!"
echo "***************"
echo "***************     Ericom Shield Version: $Version is up and running"
echo "$(date): Ericom Shield Version: $Version is up and running" >>"$LOGFILE"
