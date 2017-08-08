#!/bin/bash
############################################
#####   Ericom Shield Status              #####
#######################################BH###
ES_PATH="/usr/local/ericomshield"
ES_RUN="$ES_PATH/run.sh"
ES_SWARM_FILE="$ES_PATH/.esswarm"

#Check if we are root
if (( $EUID != 0 )); then
#    sudo su
        echo " Please run it as Root"
        echo "sudo" $0 $1 $2
        exit
fi
cd $ES_PATH

NUM_EXPECTED_SERVICES=$(grep -c image docker-compose.yml)
NUM_RUNNING_SERVICES=$(docker service ls |wc -l)

if [ "$1" == "-a" ]; then
  docker service ls
fi

if [ $NUM_RUNNING_SERVICES -ge  $NUM_EXPECTED_SERVICES ]; then
   echo "***************     Ericom Shield is running"
  else
   echo " Ericom Shield is not running properly on this system"
   exit 1
fi

exit 0
