#!/bin/bash
############################################
#####   Ericom Shield ShowVersion      #####
#######################################BH###

#Check if we are root
if (( $EUID != 0 )); then
#    sudo su
        echo " Please run it as Root"
        echo "sudo" $0 $1 $2
        exit
fi

ES_PATH=/usr/local/ericomshield
cd $ES_PATH

NUM_EXPECTED_SERVICES=$(grep -c image docker-compose.yml)
NUM_RUNNING_SERVICES=$(docker service ls |wc -l)
NUM_EXPECTED_REP=$(docker service ls | grep -c "/[1-2] ")
NUM_EXPECTED_REP=$[$NUM_EXPECTED_REP+1]
NUM_RUNNING_REP=$(docker service ls | grep -c "[1-2]/")
BROWSER_RUNNING=$(docker service ls | grep browser | awk {'print $4'} | grep -c '0/0')
echo $BROWSER_RUNNING
if [ $BROWSER_RUNNING -eq 0 ]; then
   NUM_RUNNING_REP=$[$NUM_RUNNING_REP+1]
fi

if [ "$1" == "-a" ]; then
  docker service ls
fi

if [ $NUM_RUNNING_SERVICES -ge  $NUM_EXPECTED_SERVICES ]; then
   if [ $NUM_RUNNING_REP -ge  $NUM_EXPECTED_REP ]; then
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
