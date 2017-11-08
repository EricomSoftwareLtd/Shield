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

Ericom Shield will be installed and ericomshield service will be available

#####   Multi-Node Deployment     #####

After installing Ericom Shield on the Master, you can add additional Nodes 
Pre-Requesite for new Node: Linux Ubuntu 16.04

Open a Shell on a New Node:

Prepare the node to join Ericom Shield Swarm Cluster:

*sudo wget "https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/master/SetupNode/prepare-node.sh"*

*sudo chmod +x prepare-node.sh*

*sudo ./prepare-node.sh*

Ericom Shield will be installed and ericomshield service will be available
=======
On the Master Machine:

Ericom Shield Setup Cluster Node:

*sudo wget "https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/master/SetupNode/ericomshield-setup-node.sh"*

*sudo chmod +x ericomshield-setup-node.sh*

*sudo ./ericomshield-setup-node.sh -ips xxx.xx.xx.xx,yy.yy.yy.yy -mng -b*

And more commands you can use:

[-ips|--machines-ip] IPs of machines to append separated by commas (',')

[-b|--browser] Allow shield-browser containers to be allocated on this node. Defines the node as browsers farm component

[-sc|--shield-core] Allow shield-core containers to be allocated on this node. Defines the node as core component

[-mng|--management] Allow to shield managment container to be allocated on node. Defines the node as management component

[-u|--user] ssl username

[-l|--leader] leader ip

[-m|--mode] Mode to join should be worker|manager (the default is worker)

[-n|--name] Node name prefix. should be only letters. default WORKER. Final looks (NAME) + node number

[-c|--certificate] path to certificate file. Should include public and private keys (file name + .pub).

[-t|--token] Token to join the swarm deafult will be provided by current cluster ('docker swarm join-token -q worker|manager')
