#!/bin/bash -x
############################################
#####   Ericom Shield Installer        #####
#######################################BH###


MACHINE_USER=
MACHINE_IPS=
MACHINES=
SWARM_TOKEN=
LEADER_IP=
CERTIFICATE_FILE=./shield_cert
DOCKER_INSTALL_SCRIPT_URL="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/jenkins/SetupNode/install-docker.sh"

command_exists() {
	command -v "$@" > /dev/null 2>&1
}


print_usage() {
    echo "Usage: ericomshield-setup-node.sh
        -u|--user ssl usename
        [-t|--token] Token to join to swarm deafult will be provide from current cluster
        -l|--leader leader ip
        [-m|--mode] Mode to join should be worker|manager default worker
        -ips|--machines-ip IPs of machines to append separated by ','"
}


create_generic_machines() {
    counter=0
    for ip in $MACHINE_IPS; do
        MACHINE_NAME="WORKER$counter"
        docker-machine create \
            -d "generic" --generic-ip-address $ip \
            --generic-ssh-key $CERTIFICATE_FILE \
            --generic-ssh-user $MACHINE_USER \
            --engine-install-url $DOCKER_INSTALL_SCRIPT_URL  $MACHINE_NAME
        counter=$(($counter + 1))
        if [ -z "$MACHINES" ]; then
           MACHINES=$MACHINE_NAME
        else
           MACHINES="$MACHINES $MACHINE_NAME"
        fi
    done
}

make_tmpfs_mount() {
    docker-machine ssh $name "sudo mkdir -p /media/containershm"
    docker-machine ssh $name "sudo mount -t tmpfs -o size=2G tmpfs /media/containershm"
    docker-machine ssh $name <<- EOF
        sudo su
        echo 'tmpfs   /media/containershm     tmpfs   rw,size=2G      0       0' >> /etc/fstab
EOF
}

join_machines_to_swarm() {
    for name in $MACHINES; do
        eval $(docker-machine env $name)
        docker swarm join --token $SWARM_TOKEN $LEADER_IP:2377
    done

    eval $(docker-machine env -u)

    #should change to FS table mount
    for name in $MACHINES; do
        ssh -i $CERTIFICATE_FILE -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $MACHINE_USER@$(docker-machine ip $name) [ ! -d /media/containershm ] &&  make_tmpfs_mount $name;
    done
}

fetch_join_token() {

    TOKEN_MODE=$MODE

    if [ -z "$TOKEN_MODE" ]; then
        TOKEN_MODE=worker
    fi

    echo $(docker swarm join-token -q $TOKEN_MODE)

}

if ! command_exists docker-machine; then
    echo "###################################### Install docker machine ################################"
    sudo curl -L https://github.com/docker/machine/releases/download/v0.12.2/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine && \
    sudo chmod +x /usr/local/bin/docker-machine
fi


while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -u|--user)
        MACHINE_USER="$2"
        shift
        ;;
    -t|--token)
        SWARM_TOKEN="$2"
        shift
        ;;
    -l|--leader)
        LEADER_IP="$2"
        shift
        ;;
    -m|--mode)
        MODE="$2"
        shift
        ;;
    -ips|--machines-ip)
          IFS=',' read -r -a array <<< "$2"
          MACHINE_IPS="${array[@]}"
          shift
        ;;
    -c|--certificate)
        CERTIFICATE_FILE="$2"
        shift
        ;;
    esac
    shift
done

if [ -z "$MACHINE_USER" ]; then
    echo "ssh user is empty"
    print_usage
    exit 1
fi

if [ -z "$SWARM_TOKEN" ]; then
    SWARM_TOKEN=$(fetch_join_token)
fi

if [ -z "$LEADER_IP" ]; then
    echo "leader is required parameter"
    print_usage
    exit 1
fi

if [ -z "$MACHINE_IPS" ]; then
    echo "IPs of nodes required at least one"
    print_usage
    exit 1
fi

echo "Machine IPS: $MACHINE_IPS"

set -e
create_generic_machines
set +e
join_machines_to_swarm


