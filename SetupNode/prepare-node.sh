#!/bin/bash

MACHINE_USER=$(whoami)

echo "########################## $MACHINE_USER Going to be super user #########################################"

#sudo su

#echo "################################################ Make sudo without password ###################################"

echo "$MACHINE_USER    ALL=(ALL:ALL)   NOPASSWD: ALL" >> ./test