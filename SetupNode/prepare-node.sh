#!/bin/bash

MACHINE_USER=$(whoami)

sudo echo "$MACHINE_USER    ALL=(ALL:ALL)   NOPASSWD: ALL" >> /etc/sudoers