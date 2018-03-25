# Ericom Shield
############################################
#####   Ericom Shield Installation     #####
#######################################BH###

Pre-Requesite: Linux Ubuntu 16.04

Open a Shell:
Type the following commands:

*wget "https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/master/Setup/ericomshield-setup.sh"*

*chmod +x ericomshield-setup.sh*

*./ericomshield-setup.sh*

Ericom Shield will be installed and ericomshield service will be available

#####   Multi-Node Deployment     #####

After installing Ericom Shield on the Master, you can add additional Nodes 
Pre-Requesite for new Node: Linux Ubuntu 16.04

Open a Shell on a New Node:

Prepare the node to join Ericom Shield Swarm Cluster:

*sudo wget "https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/master/SetupNode/prepare-node.sh"*

*sudo chmod +x prepare-node.sh*

*sudo ./prepare-node.sh*

=======
On the Master Machine:

Ericom Shield Setup Node:

*sudo wget "https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/master/SetupNode/ericomshield-setup-node.sh"*

*sudo chmod +x ericomshield-setup-node.sh*

*sudo ./ericomshield-setup-node.sh -ips xx.xx.xx.xx,yy.yy.yy.yy -mng -b*
