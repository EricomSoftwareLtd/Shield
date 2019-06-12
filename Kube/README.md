# Ericom Shield (K8s) Readme

Welcome! This repository houses all of the assets required to deploy Ericom Shield on Kubernetes
We're very pleased that you want to contribute!

## Deploying Shield Browser Farm Locally

It is recommended to have at least 2 machines for this deployment. One machine to run Rancher and a second machine to run Kubernetes and Shield. Best practice is an additional, third machine to run kubectl and helm on it, but if not available, these services can run on the same machine running Rancher.

### 1. Create a cluster on Rancher

Note: Rancher is a well-known software platform that enables easy deployment and management of Docker and Kubernetes products in production. Rancher is generally installed on an external machine (not part of the cluster), however it can be installed on a cluster machine but the default ports will have to be changed.
     
Install Rancher and create a Kubernetes cluster using these instructions:

[Rancher](https://github.com/EricomSoftwareLtd/Shield/blob/Dev/Kube/Rancher-README.md)



### 2. Add A New Node To An Existing Cluster

If a new node should be added to an existing cluster, follow these steps:

Install Docker

```bash
curl -s -o install-docker.sh https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Dev/Kube/scripts/install-docker.sh
sudo chmod +x install-docker.sh
sudo ./install-docker.sh
```

Install Rancher Agent on Worker Node

Go to Rancher. In the Clusters table, select the desired cluster. On the right, select the ``Edit`` option from the menu.
<insert image AddCluster1>


Scroll down to the ``Customize Node Run Command``. Select the required check boxes and copy the command.
Run the copied command in the new node machine. Wait until the cluster is ready.
After the node is joined to the cluster, a green message appears in the bottom of the page. Click ``Done``.

### 3. Install kubectl

```bash
curl -s -o install-kubectl.sh https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Dev/Kube/scripts/install-kubectl.sh
sudo chmod +x install-kubectl.sh
sudo ./install-kubectl.sh
```

Update ~/.kube/config with Kubeconfig from Rancher:
 - Click on your Cluster, then on ``Kubeconfig file`` option. Then Copy to Clipboard
 - On your Linux machine, create a file named ``~/.kube/config`` with the content of the file
 
Check that kubectl is configured well (client and server):

```bash
kubectl version
Client Version: version.Info{Major:"1", Minor:"14", GitVersion:"v1.14.3", GitCommit:"5e53fd6bc17c0dec8434817e69b04a25d8ae0ff0", GitTreeState:"clean", BuildDate:"2019-06-06T01:44:30Z", GoVersion:"go1.12.5", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"13", GitVersion:"v1.13.5", GitCommit:"2166946f41b36dea2c4626f90a77706f426cdea2", GitTreeState:"clean", BuildDate:"2019-03-25T15:19:22Z", GoVersion:"go1.11.5", Compiler:"gc", Platform:"linux/amd64"}
```

### 4. Install Helm

```bash
curl -s -o install-helm.sh https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Dev/Kube/scripts/install-helm.sh
sudo chmod +x install-helm.sh
sudo ./install-helm.sh
```

### 5. Add Shield Repository
*** You need a valid Password for the Shield Helm Repository (please ask Ericom)

```bash
curl -s -o add-shield-repo.sh  https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Dev/Kube/scripts/add-shield-repo.sh
sudo chmod +x add-shield-repo.sh
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

click on your cluster and go to **Namespaces**
Choose shield deployments and click on the ... on the right
Click on ``Move`` and select **Default**

Now, Click on your Cluster (close to the Rancher Icon) and select Default under your Cluster Name

When you see in Workload that the system is up and running (or by running helm status shield),
you can connect your shield-core system to the Browser Farm
Server IP will be the IP of your Worker Node, IP will be 30140 and 30080 for Proxy and Web-server respectively

We really appreciate your contributions to our site and our documentation!:)
