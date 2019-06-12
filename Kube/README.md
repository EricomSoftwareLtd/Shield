# Ericom Shield (K8s) Readme

Welcome! This repository houses all of the assets required to deploy Ericom Shield on Kubernetes
We're very pleased that you want to contribute!

## Deploying Shield Browser Farm Locally

It is recommended to have at least 2 machines for this deployment. One machine to run Rancher and a second machine to run Kubernetes and Shield. Best practice is an additional, third machine to run kubectl and helm on it, but if not available, these services can run on the same machine running Rancher.

### 1. Create A Cluster On Rancher

Note: Rancher is a well-known software platform that enables easy deployment and management of Docker and Kubernetes products in production. Rancher is generally installed on an external machine (not part of the cluster), however it can be installed on a cluster machine but the default ports will have to be changed.
     
Install Rancher and create a Kubernetes cluster using these instructions:

[Rancher](https://github.com/EricomSoftwareLtd/Shield/blob/Dev/Kube/Rancher-README.md)


### 2. Add Node/s To An Existing Cluster

If a new node should be added to an existing cluster, follow these steps:

**Install Docker**

```bash
curl -s -o install-docker.sh https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Dev/Kube/scripts/install-docker.sh
sudo chmod +x install-docker.sh
sudo ./install-docker.sh
```

**Install Rancher Agent on Worker Node**

Go to Rancher. In the Clusters table, select the desired cluster. On the right, select the ``Edit`` option from the menu.
<insert image AddCluster1>


Scroll down to the ``Customize Node Run Command``. Select the required check boxes and copy the command.
Run the copied command in the new node machine. Wait until the cluster is ready.
After the node is joined to the cluster, a green message appears in the bottom of the page. Click ``Done``.

Once all nodes are added to the cluster and the cluster is completely ready, it is time to **deploy** Shield.

### 3. Install Kubectl

On the first (Rancher) machine, run these commands to install Kubectl:

```bash
curl -s -o install-kubectl.sh https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Dev/Kube/scripts/install-kubectl.sh
chmod +x install-kubectl.sh
sudo ./install-kubectl.sh
```
Update ~/.kube/config with Kubeconfig:

* In Rancher, click on the Cluster, then on ``Kubeconfig File`` option (top right). Scroll down and select the ``Copy to Clipboard`` option.
* On the Linux machine, create a file named ``~/.kube/config`` (using sudo) and copy the content of the file.
 
Once the file is created, check that kubectl is configured properly (client and server):

``sudo kubectl version``

The expected outcome is:

``Client Version: version.Info{Major:"1", Minor:"14", GitVersion:"v1.14.3", GitCommit:"5e53fd6bc17c0dec8434817e69b04a25d8ae0ff0", GitTreeState:"clean", BuildDate:"2019-06-06T01:44:30Z", GoVersion:"go1.12.5", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"13", GitVersion:"v1.13.5", GitCommit:"2166946f41b36dea2c4626f90a77706f426cdea2", GitTreeState:"clean", BuildDate:"2019-03-25T15:19:22Z", GoVersion:"go1.11.5", Compiler:"gc", Platform:"linux/amd64"}
``

### 4. Install Helm

```bash
curl -s -o install-helm.sh https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Dev/Kube/scripts/install-helm.sh
chmod +x install-helm.sh
sudo ./install-helm.sh
```

### 5. Add Shield Repository
*** You need a valid Password for the Shield Helm Repository (please ask Ericom)

```bash
curl -s -o add-shield-repo.sh  https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Dev/Kube/scripts/add-shield-repo.sh
chmod +x add-shield-repo.sh
sudo ./add-shield-repo.sh <-d|--dev> -p PASSWORD
helm search shield
```

Verify that your repository is properly configured by running

```bash
helm search shield
```

the result should be something like:

```bash
NAME                    CHART VERSION   APP VERSION     DESCRIPTION
shield-repo/shield      19.01.471       19.01.Build_461 A Helm chart for installing Ericom Shield for Kubernetes
```

### 6. Deploy Shield

```bash
curl -s -o deploy-shield.sh https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Dev/Kube/scripts/deploy-shield.sh
chmod +x deploy-shield.sh
sudo ./deploy-shield.sh
```

### 7. Move shield-services to "Default" project

In Rancher, click on the cluster and go to ``Projects/Namespaces`` (top bar).
Choose Shield deployments and click on the ... on the right
Click on ``Move`` and select **Default**

Now, Click on your Cluster (close to the Rancher Icon) and select Default under your Cluster Name

When you see in Workload that the system is up and running (or by running helm status shield),
you can connect your shield-core system to the Browser Farm
Server IP will be the IP of your Worker Node, IP will be 30140 and 30080 for Proxy and Web-server respectively
