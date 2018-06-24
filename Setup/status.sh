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

#Number of running services expected shield-browser
NUM_RUNNING_SERVICES=$(docker service ls | grep -v shield-browser | grep -c shield)
NUM_RUNNING_SERVICES=$((NUM_RUNNING_SERVICES + 1)) #Adding 1 for shield-browser

#Number of services with expected replicas >0 and less than 10 (browsers)
NUM_EXPECTED_REP=$(docker service ls | grep -v shield-browser | grep -c "/[1-9] ")
NUM_EXPECTED_REP=$((NUM_EXPECTED_REP + 1)) #Adding 1 for shield-browser

#Number of services with running replicas >0 except browsers
NUM_RUNNING_REP=$(docker service ls | grep -v shield-browser | grep -c "[1-9]/")

#Check if number of running instances for Browser service is >0
BROWSER_RUNNING=$(docker service ls | grep shield-browser | grep -c ' 0/')
if [ $BROWSER_RUNNING -eq 0 ]; then
    NUM_RUNNING_REP=$((NUM_RUNNING_REP + 1))
fi

ES_VER_FILE="$ES_PATH/shield-version.txt"
function get_container_tag() {
    CONTAINER_TAG="$(grep -r 'shield-autoupdate' $ES_VER_FILE | cut -d' ' -f2)"
    if [ "$CONTAINER_TAG" = "" ]; then
        CONTAINER_TAG="shield-autoupdate:180614-12.23-2393"
    fi
}

function print_usage() {
    echo "Usage: $0 [-a | --all] [-s | --services] [-n | --nodes] [-e | --errors] [-h | --help]"
}

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -a | --all)
        docker service ls
        echo "------------------------------------------------------------------------------"
        echo
        var=$(curl --silent -q --proxy http://127.0.0.1:3128 http://shield-stats -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36" 2>&1)
        var=${var//"<br>"/" | "}
        var=${var//"</h1>"/}
        var=${var//"<b>"/" "}
        var=${var//"</b>"/}
        var=${var//"<i>"/" | "}
        var=${var//"</i>"/}
        var=${var//"<p>"/" | "}
        var=${var//"<blockquote>"/}
        var=${var//"</blockquote>"/}
        echo ${var:16:283}
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
    -e | --errors)
        get_container_tag
        docker run --rm -it \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v $(which docker):/usr/bin/docker \
            -v "$ES_PATH:$ES_PATH" \
            "securebrowsing/$CONTAINER_TAG" status -e
        ;;
    -h | --help)
        print_usage "$0"
        echo "           -a --all - lists all services in the system"
        echo "           -s --services - prints a detailed report of the services in the system and which service runs on which node"
        echo "           -n --nodes - lists the nodes in the multi-machine system, including data about each node"
        echo "           -e --errors - lists the services errors in the single or multi-machine system, including data about each failed service"
        exit
        ;;
    *)
        print_usage "$0"
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
