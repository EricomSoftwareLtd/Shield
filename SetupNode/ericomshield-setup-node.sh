#!/bin/bash -x
############################################
#####   Ericom Shield Installer        #####
#######################################BH###


MACHINE_USER="ozlevka"
MACHINE_IPS="10.0.0.104 10.0.0.105"
MACHINES=
SWARM_TOKEN="SWMTKN-1-2mu1n72c61jx0w26q44glcmoar6sm5w0i57uvj2yc3l48kr717-1968b31fzcg89bnoua7euhe01"
LEADER_IP=10.0.0.1
DOCKER_INSTALL_SCRIPT_URL="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/jenkins/SetupNode/install-docker.sh"

command_exists() {
	command -v "$@" > /dev/null 2>&1
}


create_machines() {
    counter=0
    for ip in $MACHINE_IPS; do
        MACHINE_NAME="WORKER$counter"
        docker-machine create \
            -d "generic" --generic-ip-address $ip \
            --generic-ssh-key ./shield_cert \
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

join_machines_to_swarm() {
    for name in $MACHINES; do
        eval $(docker-machine env $name)
        docker swarm join --token $SWARM_TOKEN $LEADER_IP:2377
    done

    eval $(docker-machine env -u)

    #should change to FS table mount
    for name in $MACHINES; do
        docker-machine ssh $name "sudo mkdir -p /tmp/containershm"
        docker-machine ssh $name "sudo mount -t tmpfs -o size=2G tmpfs /tmp/containershm"
    done
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
    esac
    shift
done

set -e
create_machines
set +e
join_machines_to_swarm


