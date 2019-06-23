#!/bin/bash
############################################
#####   Ericom Shield Installer for AWS  ###
#######################################BH###

wget https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Dev/Setup/ericomshield-setup.sh
chmod +x ericomshield-setup.sh
bash ./ericomshield-setup.sh --Dev --force -approve-eula
bash
