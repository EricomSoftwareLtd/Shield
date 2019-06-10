# Ericom Shield (K8s) Readme

Welcome! This repository houses all of the assets required to deploy Ericom Shield on Kubernetes
We're very pleased that you want to contribute!

## Deploying Shield Browser Farm Locally

### 1. Create a cluster on Rancher

     - Note: If Rancher is not installed follow the instructions in:

[Rancher-README](https://github.com/EricomSoftwareLtd/Shield/Kube/blob/master/Rancher-README.md)

     - Create a Cluster from Rancher:
[Create-Cluster](https://github.com/EricomSoftwareLtd/Shield/Kube/blob/master/Rancher-README.md#3-create-your-cluster)

### 2. Add your node to the Cluster

      - Install Docker

```bash
      curl -s -o install-docker.sh https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Kube/Dev/scripts/install-docker.sh
      sudo chmod +x install-docker.sh
      sudo ./install-docker.sh
```

      - Install Rancher Agent on Worker Node
      - Copy and Run Command from Rancher

### 3. Install kubectl

```bash
      curl -s -o install-kubectl.sh https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Kube/Dev/scripts/install-kubectl.sh
      sudo chmod +x install-kubectl.sh
      sudo ./install-kubectl.sh
      - Update ~/.kube/config with Kubeconfig from Rancher:
```

### 4. Install Helm

```bash
      curl -s -o install-helm.sh https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Kube/Dev/scripts/install-helm.sh
      sudo chmod +x install-helm.sh
      sudo ./install-helm.sh
```

### 5. Add Shield Repository

```bash
      curl -s -o add-shield-repo.sh  https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Kube/Dev/scripts/add-shield-repo.sh
      sudo chmod +x add-shield-repo.sh
      sudo ./add-shield-repo.sh <-d|--dev>
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
      curl -s -o deploy-shield.sh https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Kube/Dev/scripts/deploy-shield.sh
      chmod +x deploy-shield.sh
      sudo ./deploy-shield.sh
```

### 7. Move shield-services to "Default" project

click on your cluster and go to Namespaces
Choose shield deployments and click on the ... on the right
Click on Move and select "Default"

Now, Click on your Cluster (close to the Rancher Icon) and select Default under your Cluster Name

When you see in Workload that the system is up and running (or by running helm status shield),
you can connect your shield-core system to the Browser Farm
Server IP will be the IP of your Worker Node, IP will be 30140 and 30080 for Proxy and Web-server respectively


We really appreciate your contributions to our site and our documentation!:)
