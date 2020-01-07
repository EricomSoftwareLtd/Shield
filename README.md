Ericom Shield (K8s) Readme
Welcome! This repository includes all the steps required to deploy Ericom Shield on Kubernetes

Install Shield
Install Shield:

wget https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/master/Kube/scripts/install-shield.sh
chmod +x ./install-shield.sh
sudo ./install-shield.sh -R --label -p <PASSWORD>
Installation Process can take 10-30 minutes depending on the machine and the internet connection

Help:

sudo ./install-shield.sh

-R |--ranchercli: (Deploy using Rancher CLI)

-l |--label: Set all labels on the created node

-p : Password for Shield Repository

-v |--version : Install a specific version (Branch Name)

To connect to Rancher Admin Console, connect to the Host IP where the Admin is running and use port 8443.  
To connect to Shield Admin Console, connect to the Host IP where the Admin is running and use port 30181.  
To connect to Shield on the Proxy Port, connect to the Host IP where the Shield-Proxy Component is running on 3128 port.  
