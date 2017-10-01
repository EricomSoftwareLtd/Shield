# Ericom Shield
############################################
#####   Ericom Shield Installation     #####
#######################################BH###

Pre-Requesite: Linux Ubuntu 16.04

Open a Shell:
Create a new Folder and go to this folder

Type the following commands:

*wget "https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/master/Setup/ericomshield-setup.sh"*

*chmod +x ericomshield-setup.sh*

*./ericomshield-setup.sh*

Prepare node for cluster:

`curl -sS https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/multinode/SetupNode/prepare-node.sh >  prepare-node.sh  \
 && chmod +x prepare-node.sh && sudo ./prepare-node.sh`

Ericom Shield will be installed and ericomshield service will be available 
