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

`curl -sS https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/multinode/SetupNode/prepare-node.sh >  prepare-node.sh  \
 && chmod +x prepare-node.sh && sudo ./prepare-node.sh`

<<<<<<< HEAD
<<<<<<< HEAD
Ericom Shield will be installed and ericomshield service will be available 
=======
Ericom Shield will be installed and ericomshield service will be available
=======
On the Master Machine:
>>>>>>> master

Ericom Shield Setup Cluster Node:

`curl -sS https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/multinode/SetupNode/ericomshield-setup-node.sh > ericomshield-setup-node.sh \
&& chmod +x ericomshield-setup-node.sh`

Run sudo ./ericomshield-setup-node.sh -ips xxx.xx.xx.xx,yy.yy.yy.yy -mng -b

And more commands you can use:

-ips|--machines-ip IPs of machines to append separated by ','

[-b|--browser] Allow shield-browser containers to be allocated on this node

[-sc|--shield-core] Allow shield-core containers to be allocated on this node

[-mng|--management] Allow to shield managment container to be allocated on node

[-u|--user] ssl usename

[-t|--token] Token to join to swarm deafult will be provide from current cluster

[-l|--leader] leader ip

[-c|--certificate] path to sertificate file. Should be together private and public (file name + .pub)

[-t|--token] swarm join token 'docker swarm join-token -q worker|manager'

[-m|--mode] Mode to join should be worker|manager default worker

[-n|--name] Node name prefix. should be only letters. default WORKER. Final looks (NAME) + node number

-ips|--machines-ip IPs of machines to append separated by ','

[-b|--browser] Allow shield-browser containers to be allocated on this node

[-sc|--shield-core] Allow shield-core containers to be allocated on this node

[-mng|--management] Allow to shield managment container to be allocated on node

