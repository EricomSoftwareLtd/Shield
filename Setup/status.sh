#!/bin/bash
############################################
#####   Ericom Shield Status           #####
#######################################BH###

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo " Please run it as Root"
    echo "sudo" $0 $1 $2
    exit
fi

ES_PATH=/usr/local/ericomshield
cd $ES_PATH

NUM_EXPECTED_SERVICES=$(grep -c image docker-compose.yml)
NUM_RUNNING_SERVICES=$(docker service ls | wc -l)
NUM_EXPECTED_REP=$(docker service ls | grep -c "/[1-5] ")
NUM_EXPECTED_REP=$((NUM_EXPECTED_REP + 1))
NUM_RUNNING_REP=$(docker service ls | grep -c " [1-2]/")
BROWSER_RUNNING=$(docker service ls | grep browser | awk {'print $4'} | grep -c '0/0')
if [ $BROWSER_RUNNING -eq 0 ]; then
    NUM_RUNNING_REP=$((NUM_RUNNING_REP + 1))
fi


while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -a | --all)
        docker service ls
        echo "------------------------------------------------------------------------------"
        echo
        var=$(curl --silent -q --proxy http://127.0.0.1:3128 http://shield-stats 2>&1)
        echo ${var:16:330}
        echo
        echo "------------------------------------------------------------------------------"
        echo
        ;;
    -s | --services)
          ./addnodes.sh --status
        ;;
    -n | --nodes)
          ./addnodes.sh --node-status
        ;;
    -h | --help)
        echo "Usage: $0 [-a | --all] [-s | --services] [-n | --nodes] [-h | --help]"
        echo "           -a --all - lists all services in the system"
        echo "           -s --services - prints a detailed report of the services in the system and which service runs on which node"
        echo "           -n --nodes - lists the nodes in the multi-machine system, including data about each node"
        exit
        ;;
    *)
        echo "Usage: $0 [-a | --all] [-s | --services] [-n | --nodes] [-h | --help]"
        exit
        ;;
    esac
    shift
done

if [ $NUM_RUNNING_SERVICES -ge $NUM_EXPECTED_SERVICES ]; then
    if [ $NUM_RUNNING_REP -ge $NUM_EXPECTED_REP ]; then
        echo "***************     Ericom Shield is running"
    else
        echo "***************     Ericom Shield is loading  ($NUM_RUNNING_REP/$NUM_EXPECTED_REP)"
        exit 1
    fi
else
    echo " Ericom Shield is not running properly on this system"
    exit 1
fi

exit 0
