# Ericom Shield (K8s) Readme

Welcome! This repository houses all of the assets required to deploy Ericom Shield on Kubernetes
We're very pleased that you want to contribute!

## Deploying Shield Browser Farm Locally

It is recommended to have, a dedicated machine to run Rancher and Kubectl/Helm Services in order to create the cluster and deploy Shield on it.

### 1. Create A Cluster On Rancher

Note: Rancher is a well-known software platform that enables easy deployment and management of Docker and Kubernetes products in production.  installed on a cluster machine but the default ports will have to be changed.
     
Install Rancher and create a Kubernetes cluster using these instructions:

[Rancher](https://github.com/EricomSoftwareLtd/Shield/blob/Dev/Kube/Rancher-README.md)


### 2. Add Node/s To An Existing Cluster

If a new node should be added to an existing cluster, follow these steps:

**Configure OS Settings**

```bash
      curl -s -o configure-sysctl-values.sh https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Dev/Kube/scripts/configure-sysctl-values.sh
      sudo chmod +x configure-sysctl-values.sh
      sudo ./configure-sysctl-values.sh
```

**Install Docker**

```bash
curl -s -o install-docker.sh https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Dev/Kube/scripts/install-docker.sh
sudo chmod +x install-docker.sh
sudo ./install-docker.sh
```

**Install Rancher Agent on Worker Node**

Go to Rancher. In the Clusters table, select the desired cluster. On the right, select the ``Edit`` option from the menu.
![addCluster](https://user-images.githubusercontent.com/24224420/59359118-75771680-8d36-11e9-9ab0-3249f1e15210.png)

Scroll down to the ``Customize Node Run Command``. Select the required check boxes and copy the command.
For all-in-one, check All.
For a Cluster-Management Node, check etcd and Control Plane checkboxes.
For a Worker only Node, check Worker checkbox only.

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
**Update ~/.kube/config with Kubeconfig**

* In Rancher, click on the Cluster, then on ``Kubeconfig File`` option (on the right). Scroll down and select the ``Copy to Clipboard`` option.
* On the Linux machine, create a file named ``~/.kube/config`` (using sudo) and copy the content of the file.
 
Once the file is created, check that kubectl is configured properly (client and server):

``sudo kubectl version``

The expected outcome should be something like:

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
```

Verify that your repository is properly configured by running

```bash
helm search shield
```

The result should be something like:

![image](https://user-images.githubusercontent.com/24224420/59362670-8a56a880-8d3c-11e9-9b68-754f726177eb.png)

### 6. Deploy Shiel
Note: deploy-shield script is provided as an example on how to deploy the system in an all-in-one deployment
For a more complex deployment, the node labels have to be set on each node according to the desired deployment, 
then Shield should be deployed using Helm.

```bash
curl -s -o deploy-shield.sh https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Dev/Kube/scripts/deploy-shield.sh
chmod +x deploy-shield.sh
sudo ./deploy-shield.sh
```

### 7. Move Shield-Services To Default Project

In Rancher, click on the cluster.
Select the Shield components (management, proxy, farm-services, elk) and click on the ``Move`` option on top. 
Select **Default** and confirm. The Shield components are now displayed under the Default project.

![image](https://user-images.githubusercontent.com/24224420/59365676-9e50d900-8d41-11e9-97bb-8d088ef63b89.png)

Now, Click on your Cluster (close to the Rancher Icon) and select Default under your Cluster Name

![image](https://user-images.githubusercontent.com/24224420/59365822-e3750b00-8d41-11e9-8483-801a5fea47fb.png)


When you see under ``Workloads`` that the system is up and running (or by running helm status shield),
you can connect to Shield (using the IP Address of the second machine, the one running Kubernetes).
To browser Shield, connect using the 3128 port. 
To connect to Shield Admin Console, use port 30181.
