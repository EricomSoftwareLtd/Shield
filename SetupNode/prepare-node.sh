#!/bin/bash

MACHINE_USER=$(whoami)

echo "########################## $MACHINE_USER Going to prepare super user #########################################"

COMMAND="$MACHINE_USER ALL=(ALL:ALL) NOPASSWD: ALL"

echo $COMMAND  | sudo EDITOR='tee -a' visudo