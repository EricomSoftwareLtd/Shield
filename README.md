# Ericom Shield (K8s) Readme

Welcome! This repository includes all the steps required to deploy Ericom Shield on Kubernetes

## Install Shield

Install Shield:

```bash
wget https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/master/Kube/scripts/install-shield.sh
chmod +x ./install-shield.sh
sudo ./install-shield.sh -d -p Ericom98***$ -l

```
Installation Process can take 10-30 minutes depending on the machine and the internet connection

Help:

sudo ./install-shield.sh

-l |--label: Set all labels on the created node  

-p <PASSWORD>: Password for Shield   

-v |--version <version-name>: Install a specific version (i.e. YY.MM.Build)

To connect to Rancher Admin Console, connect to the Host IP where the Admin is running and use port **8443**.  
To connect to Shield Admin Console, connect to the Host IP where the Admin is running and use port **30181**.  
To connect to Shield on the Proxy Port, connect to the Host IP where the Shield-Proxy Component is running on **3128** port.  
