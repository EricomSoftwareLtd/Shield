#!/bin/bash


while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -u|--user)
        MACHINE_USE="$2"
        shift
     ;;
    -os|--os-user)
        MACHINE_USER=$(whoami)
    ;;
    esac
    shift
done


if [ -z "$MACHINE_USER" ]; then
    sudo useradd ericom
    MACHINE_USER="ericom"
fi

echo "########################## $MACHINE_USER Going to prepare super user #########################################"

COMMAND="$MACHINE_USER ALL=(ALL:ALL) NOPASSWD: ALL"

echo $COMMAND  | sudo EDITOR='tee -a' visudo