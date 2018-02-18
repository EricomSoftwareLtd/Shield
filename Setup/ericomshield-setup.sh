#!/bin/bash
############################################
#####   Ericom Shield Installer        #####
#######################################BH###

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo "Usage: $0 [-force] [-autoupdate] [-dev] [-staging] [-usage] [-pocket]"
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi
ES_PATH="/usr/local/ericomshield"
ES_BACKUP_PATH="/usr/local/ericomshield/backup"
LOGFILE="$ES_PATH/ericomshield.log"
DOCKER_VERSION="17.12.0"
UPDATE=false
UPDATE_NEED_RESTART=false
UPDATE_NEED_RESTART_TXT="#UNR#"
ES_DEV_FILE="$ES_PATH/.esdev"
ES_STAGING_FILE="$ES_PATH/.esstaging"
ES_AUTO_UPDATE_FILE="$ES_PATH/.autoupdate"
ES_REPO_FILE="$ES_PATH/ericomshield-repo.sh"
ES_PRE_CHECK_FILE="$ES_PATH/shield_pre_install_check.sh"
ES_YML_FILE="$ES_PATH/docker-compose.yml"
ES_YML_FILE_BAK="$ES_PATH/docker-compose_yml.bak"
ES_VER_FILE="$ES_PATH/shield-version.txt"
ES_VER_FILE_BAK="$ES_PATH/shield-version.bak"
ES_uninstall_FILE="$ES_PATH/ericomshield-uninstall.sh"
EULA_ACCEPTED_FILE="$ES_PATH/.eula_accepted"
ES_MY_IP_FILE="$ES_PATH/.es_ip_address"
SUCCESS=false

ES_SETUP_VER="18.02-Setup"

DOCKER_USER="ericomshield1"
DOCKER_SECRET="Ericom98765$"
ES_CHANNEL="Production"
ES_DEV=false
ES_STAGING=false
ES_POCKET=false
ES_AUTO_UPDATE=false
ES_FORCE=false
ES_FORCE_SET_IP_ADDRESS=false
ES_RUN_DEPLOY=true
ES_CONFIG_STORAGE=yes
SWITCHED_TO_MULTINODE=false
ES_NO_BROWSERS=""

# Create the Ericom empty dir if necessary
if [ ! -d $ES_PATH ]; then
    mkdir -p $ES_PATH
    chmod 0755 $ES_PATH
fi

if [ ! -d $ES_BACKUP_PATH ]; then
    mkdir -p $ES_BACKUP_PATH
    chmod 0755 $ES_BACKUP_PATH
fi

function log_message() {
    local PREV_RET_CODE=$?
    echo "$@"
    echo "$(date): $@" | perl -ne 's/\x1b[[()=][;?0-9]*[0-9A-Za-z]?//g;s/\r//g;s/\007//g;print' >>"$LOGFILE"
    if ((PREV_RET_CODE != 0)); then
        return 1
    fi
    return 0
}

cd "$ES_PATH" || exit

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -dev)
        ES_DEV=true
        echo "ES_DEV" >"$ES_DEV_FILE"
        ES_CHANNEL="ES_DEV"
        ES_STAGING=false
        ES_AUTO_UPDATE=true # ES_AUTO_UPDATE=true for Dev Deployments
        rm -f "$ES_STAGING_FILE"
        ;;
    -staging)
        ES_STAGING=true
        echo "ES_STAGING" >"$ES_STAGING_FILE"
        ES_CHANNEL="ES_STAGING"
        ES_DEV=false
        rm -f "$ES_DEV_FILE"
        ;;
    -autoupdate)
        ES_AUTO_UPDATE=true
        ;;
    -force)
        ES_FORCE=true
        echo " " >>$ES_VER_FILE
        ;;
    -force-ip-address-selection)
        ES_FORCE_SET_IP_ADDRESS=true
        ;;
    -pocket)
        ES_POCKET=true
        echo " pocket version "
        ;;
    -restart)
        UPDATE_NEED_RESTART=true
        echo " Restart will be done during upgrade "
        ;;
    -approve-eula)
        log_message "EULA has been accepted from Command Line"
        date -Iminutes >"$EULA_ACCEPTED_FILE"
        ;;
    -no-deploy)
        ES_RUN_DEPLOY=false
        echo "Install Only (No Deploy) "
        ;;
    -no-config-storage)
        ES_CONFIG_STORAGE=no
        echo "For docker-machine stop storage configuration (No Deploy) "
        ;;
    -no-browser)
	ES_NO_BROWSERS="-no-browsers"
        echo "MultiNode: No Browsers "
        ;;

    -version)
        shift
        BRANCH="$1"
        log_message "Installing version: $BRANCH"
        ;;
    #        -usage)
    *)
        echo "Usage: $0 [-force] [-force-ip-address-selection] [-autoupdate] [-dev] [-staging] [-pocket] [-usage]"
        exit
        ;;
    esac
    shift
done

if [ -z "$BRANCH" ]; then
    BRANCH="master"
fi

if [ -f "$ES_DEV_FILE" ]; then
    ES_CHANNEL="ES_DEV"
    ES_DEV=true
fi

if [ -f "$ES_STAGING_FILE" ]; then
    ES_CHANNEL="ES_STAGING"
    ES_STAGING=true
fi

if [ "$ES_AUTO_UPDATE" == true ]; then
    echo "ES_AUTO_UPDATE" >"$ES_AUTO_UPDATE_FILE"
fi

#Check if curl is installed (-w check that the whole word is found)
if [ "$(dpkg -l | grep -w -c curl)" -eq 0 ]; then
    echo "***************     Installing curl"
    apt-get --assume-yes -y install curl
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

    failed_to_install "Aborting installation!"
}

function failed_to_install() {
    log_message "An error occurred during the installation: $1, Exiting!"

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
    while less -P"%pb\% Press h for help or q to quit" "$1" &&
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

function install_docker() {

    if [ "$(sudo docker version | grep -c $DOCKER_VERSION)" -le 1 ]; then
        echo "***************     Installing docker-engine"
        apt-get --assume-yes -y install apt-transport-https software-properties-common python-software-properties

        #Docker Installation of a specific Version
        curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        echo -n "apt-get -qq update ..."
        apt-get -qq update
        echo "done"
        sudo apt-cache policy docker-ce
        echo "Installing Docker: docker-ce=$DOCKER_VERSION~ce-0~ubuntu"
        sudo apt-get -y --assume-yes --allow-downgrades install docker-ce=$DOCKER_VERSION~ce-0~ubuntu
    else
        echo " ******* docker-engine $DOCKER_VERSION is already installed"
    fi
    if [ "$(sudo docker version | grep -c $DOCKER_VERSION)" -le 1 ]; then
        failed_to_install "Failed to Install/Update Docker, Exiting!"
    fi
}

function docker_login() {
    if [ "$(docker info | grep -c Username)" -eq 0 ]; then
        if [ "$DOCKER_USER" == " " ]; then
            echo " Please enter your login credentials to docker-hub"
            docker login
        else
            #Login and enter the credentials you received separately when prompt
            echo "docker login" $DOCKER_USER $DOCKER_SECRET
            docker login --username=$DOCKER_USER --password=$DOCKER_SECRET
        fi

        if [ $? == 0 ]; then
            echo "Login Succeeded!"
        else
            failed_to_install "Cannot Login to docker, Exiting!"
        fi
    fi
}

function update_sysctl() {
    #check if file was not updated
    curl -s -S -o "${ES_PATH}/sysctl_shield.conf" "${ES_repo_sysctl_shield_conf}"
    # append sysctl with our settings
    cat "${ES_PATH}/sysctl_shield.conf" >"/etc/sysctl.d/30-ericom-shield.conf"
    #to apply the changes:
    sysctl --load="/etc/sysctl.d/30-ericom-shield.conf"
    echo "file /etc/sysctl.d/30-ericom-shield.conf Updated!"
}

function setup_dnsmasq() {

    if [ "$(dpkg -l | grep -w -c "dnsmasq ")" -eq 0 ]; then
        echo "***************     Installing dnsmasq"
        apt-get --assume-yes -y install dnsmasq
    fi

    (
        cat <<'EOF'
log-queries
EOF
    ) >"/etc/dnsmasq.d/ericom-shield"

}

function create_shield_service() {
    echo "**************  Creating the ericomshield updater service..."
    if [ ! -f "${ES_PATH}/ericomshield-updater.service" ]; then
        # Need to download the service file only if needed and reload only if changed
        curl -s -S -o "${ES_PATH}/ericomshield-updater.service" "${ES_repo_systemd_updater_service}"
        systemctl link ${ES_PATH}/ericomshield-updater.service
        systemctl --system enable ${ES_PATH}/ericomshield-updater.service
        systemctl daemon-reload
    fi
    echo "Done!"
}

function add_aliases() {
    if [ -f ~/.bashrc ] && [ $(grep -c 'shield_aliases' ~/.bashrc) -eq 0 ]; then
        echo 'Adding Aliases in .bashrc'
        echo "" >>~/.bashrc
        echo "# EricomShield aliases" >>~/.bashrc
        echo "if [ -f ~/.shield_aliases ]; then" >>~/.bashrc
        echo ". ~/.shield_aliases" >>~/.bashrc
        echo "fi" >>~/.bashrc
    fi
    . ~/.bashrc
}

function prepare_yml() {
    echo "Preparing yml file..."
    while read -r ver; do
        if [ "${ver:0:1}" == '#' ]; then
            echo "$ver"
        else
            pattern_ver=$(echo "$ver" | awk '{print $1}')
            comp_ver=$(echo "$ver" | awk '{print $2}')
            if [ ! -z "$pattern_ver" ]; then
                echo "Changing ver: $comp_ver"
                #echo "  sed -i 's/$pattern_ver/$comp_ver/g' $ES_YML_FILE"
                sed -i "s/$pattern_ver/$comp_ver/g" $ES_YML_FILE
            fi
        fi
    done <"$ES_VER_FILE"

    #echo "  sed -i 's/IP_ADDRESS/$MY_IP/g' $ES_YML_FILE"
    sed -i "s/IP_ADDRESS/$MY_IP/g" $ES_YML_FILE
}

function switch_to_multi_node() {
    if [ $(grep -c '#      mode: global       #multi node' $ES_YML_FILE) -eq 1 ]; then
        echo "Switching to Multi-Node (consul-server -> global)"
        sed -i 's/      mode: replicated   #single node/#      mode: replicated   #single node/g' $ES_YML_FILE
        sed -i 's/      replicas: 5        #single node/#      replicas: 5        #single node/g' $ES_YML_FILE
        sed -i 's/#      mode: global       #multi node/      mode: global       #multi node/g' $ES_YML_FILE
        SWITCHED_TO_MULTINODE=true
    fi
}

function get_shield_install_files() {
    echo "Getting $ES_REPO_FILE"
    ES_repo_setup="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/ericomshield-repo.sh"
    curl -s -S -o "shield_repo_tmp.sh" $ES_repo_setup
    if [ ! -f shield_repo_tmp.sh ] || [ $(grep -c '404' shield_repo_tmp.sh) -ge 1 ]; then
        failed_to_install "Cannot Retrieve Installation files for version: $BRANCH"
    fi

    mv shield_repo_tmp.sh "$ES_REPO_FILE"

    #include file with files repository
    source $ES_REPO_FILE

    echo "Getting $ES_PRE_CHECK_FILE"
    curl -s -S -o "$ES_PRE_CHECK_FILE" "$ES_repo_pre_check"

    if [ "$ES_DEV" == true ]; then
        echo "Getting $ES_repo_dev_ver (dev)"
        curl -s -S -o shield-version-new.txt "$ES_repo_dev_ver"
    elif [ "$ES_STAGING" == true ]; then
        echo "Getting $ES_repo_staging_ver (staging)"
        curl -s -S -o shield-version-new.txt "$ES_repo_staging_ver"
    else
        echo "Getting $ES_repo_ver (prod)"
        curl -s -S -o shield-version-new.txt "$ES_repo_ver"
    fi
    if [ -f "$ES_VER_FILE" ]; then
        if [ "$(diff "$ES_VER_FILE" shield-version-new.txt | wc -l)" -eq 0 ]; then
            echo "Your EricomShield System is Up to date"
            exit 0
        else
            echo "***************     Updating EricomShield ($ES_SETUP_VER)"
            echo "$(date): New version found:  Updating EricomShield ($ES_SETUP_VER)" >>"$LOGFILE"
            UPDATE=true
            mv "$ES_VER_FILE" "$ES_VER_FILE_BAK"
            if [ $(grep -c "$UPDATE_NEED_RESTART_TXT" shield-version-new.txt) -eq 1 ]; then
                UPDATE_NEED_RESTART=true
            fi
        fi
    else
        echo "***************     Installing EricomShield ($ES_SETUP_VER)..."
        echo "$(date): Installing EricomShield ($ES_SETUP_VER)" >>"$LOGFILE"
    fi
    mv "shield-version-new.txt" "$ES_VER_FILE"

    echo "Getting $ES_YML_FILE"
    if [ -f "$ES_YML_FILE" ]; then
        mv "$ES_YML_FILE" "$ES_YML_FILE_BAK"
    fi
    curl -s -S -o "$ES_YML_FILE" "$ES_repo_yml"
    if [ "$ES_STAGING" == true ]; then
        echo "Getting $ES_repo_staging_yml (staging)"
        curl -s -S -o "$ES_YML_FILE" "$ES_repo_staging_yml"
    fi

    if [ $ES_POCKET == true ]; then
        echo "Getting $ES_repo_pocket_yml"
        curl -s -S -o "$ES_YML_FILE" "$ES_repo_pocket_yml"
    fi
    curl -s -S -o deploy-shield.sh "$ES_repo_swarm_sh"
    if [ "$ES_DEV" == true ]; then
        echo "Getting $ES_repo_dev_yml"
        curl -s -S -o "$ES_YML_FILE" "$ES_repo_dev_yml"
        curl -s -S -o deploy-shield.sh "$ES_repo_swarm_dev_sh"
    fi
    chmod +x deploy-shield.sh
}

function pull_images() {
    LINE=0
    while read -r line; do
        if [ "${line:0:1}" == '#' ]; then
            echo "$line"
        else
            arr=($line)
            if [ $LINE -eq 1 ]; then
                if [ -f .version ] && [ $(grep -c ${arr[1]} .version) -gt 1 ]; then
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
    done <"$ES_VER_FILE"
}

#############     Getting all files from Github
function get_shield_files() {
    if [ ! -f "ericomshield-setup.sh" ]; then
        curl -s -S -o ericomshield-setup.sh $ES_repo_setup
        chmod +x ericomshield-setup.sh
    fi

    if [ ! -f "autoupdate.sh" ]; then
        curl -s -S -o autoupdate.sh "$ES_repo_update"
        chmod +x autoupdate.sh
    fi

    echo "Getting $ES_repo_uninstall"
    curl -s -S -o "$ES_uninstall_FILE" "$ES_repo_uninstall"
    chmod +x "$ES_uninstall_FILE"
    curl -s -S -o run.sh "$ES_repo_run"
    chmod +x run.sh
    curl -s -S -o showversion.sh "$ES_repo_version"
    chmod +x showversion.sh
    curl -s -S -o stop.sh "$ES_repo_stop"
    chmod +x stop.sh
    curl -s -S -o status.sh "$ES_repo_status"
    chmod +x status.sh
    curl -s -S -o restart.sh "$ES_repo_restart"
    chmod +x restart.sh
    curl -s -S -o ~/show-my-ip.sh "$ES_repo_ip"
    chmod +x ~/show-my-ip.sh
    curl -s -S -o ericomshield-setup-node.sh "$ES_repo_setup_node"
    chmod +x ericomshield-setup-node.sh
    curl -s -S -o shield-nodes.sh "$ES_repo_shield_nodes"
    chmod +x shield-nodes.sh
    curl -s -S -o ~/.shield_aliases "$ES_repo_shield_aliases"
    echo "Getting $ES_repo_restore_dev_sh"
    curl -s -S -o restore.sh "$ES_repo_restore_dev_sh"
    chmod +x restore.sh
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

function set_storage_driver() {
    if [ -f /etc/docker/daemon.json ] && [ $(grep -c '"storage-driver"[[:space:]]*:[[:space:]]*"overlay2"' /etc/docker/daemon.json) -eq 1 ]; then
        echo '"storage-driver": "overlay2" in /etc/docker/daemon.json'
    else
        echo 'Setting: "storage-driver": overlay2 in /etc/docker/daemon.json'
        echo '{' >/etc/docker/daemon.json.shield
        echo '  "storage-driver": "overlay2"' >>/etc/docker/daemon.json.shield
        echo '}' >>/etc/docker/daemon.json.shield
        systemctl stop docker
        sleep 10
        mv /etc/docker/daemon.json.shield /etc/docker/daemon.json
        systemctl start docker
    fi
}

##################      MAIN: EVERYTHING STARTS HERE: ##########################

echo "***************     EricomShield Setup "$ES_CHANNEL" ..."

if [ "$ES_RUN_DEPLOY" == true ]; then
    if ! restore_my_ip || [[ $ES_FORCE_SET_IP_ADDRESS == true ]]; then
        choose_network_interface
    fi
    save_my_ip
fi

echo Docker Login: $DOCKER_USER
echo "dev=$ES_DEV"
echo "autoupdate=$ES_AUTO_UPDATE"

install_docker

if systemctl start docker; then
    echo "Starting docker service ***************     Success!"
else
    failed_to_install "Failed to start docker service"
    exit 1
fi

# No Need to Install docker compose
# install_docker_compose

get_shield_install_files

if [ "$ES_FORCE" == false ]; then
    source $ES_PRE_CHECK_FILE
    perform_env_test
fi

add_aliases

if [ "$UPDATE" == false ] && [ ! -f "$EULA_ACCEPTED_FILE" ] && [ "$ES_RUN_DEPLOY" == true ]; then
    echo 'You will now be presented with the End User License Agreement.'
    echo 'Use PgUp/PgDn/Arrow keys for navigation, q to exit.'
    echo 'Please, read the EULA carefully, then accept it to continue the installation process or reject to exit.'
    read -n1 -r -p "Press any key to continue..." key
    echo

    curl -s -S -o "$ES_PATH/Ericom-EULA.txt" "$ES_repo_EULA"
    if accept_license "$ES_PATH/Ericom-EULA.txt"; then
        log_message "EULA has been accepted"
        date -Iminutes >"$EULA_ACCEPTED_FILE"
    else
        failed_to_install "EULA has not been accepted, exiting..."
    fi
fi

setup_dnsmasq

get_shield_files

docker_login

update_sysctl

echo "Preparing yml file (Containers build number)"
prepare_yml

if [ "$UPDATE" == false ]; then
    AM_I_LEADER=true #if new installation, i am the leader
    # New Installation
    if [ "$ES_CONFIG_STORAGE" = "yes" ]; then
        set_storage_driver
    fi

    create_shield_service

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

    if [ "$AM_I_LEADER" == "true" ]; then
        if [ "$ES_RUN_DEPLOY" == "true" ]; then
            if [ "$UPDATE_NEED_RESTART" == "true" ] || [ "$STOP_SHIELD" == "true" ]; then
                log_message "Stopping Ericom Shield for Update (Downtime)"
                ./stop.sh
            else
                echo -n "stop shield-broker"
                docker service scale shield_broker-server=0
                wait_for_docker_to_settle
            fi
        fi
    fi
fi

if [ "$ES_RUN_DEPLOY" == true ]; then
    echo "pull images" #before restarting the system for upgrade
    pull_images
fi

if [ -n "$MY_IP" ]; then
    echo "Connect swarm to $MY_IP"
    export IP_ADDRESS="$MY_IP"
fi

if [ "$ES_RUN_DEPLOY" == true ] && [ "$AM_I_LEADER" == true ]; then
    echo "source deploy-shield.sh"
    source deploy-shield.sh $ES_NO_BROWSERS

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
    fi
else
    echo "Installation only (no deployment or not the leader)"
    SUCCESS=true
fi

systemctl start ericomshield-updater.service

Version=$(grep SHIELD_VER "$ES_YML_FILE")

if [ $SUCCESS == false ]; then
    echo "Something went wrong. Timeout was reached during installation. Please run ./status.sh and check the log file: $LOGFILE."
    echo "$(date): Timeout was reached during the installation" >>"$LOGFILE"
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
