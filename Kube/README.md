# Ericom Shield (K8s) Readme

Welcome! This repository includes all the steps required to deploy Ericom Shield on Kubernetes

## Prepare The Linux Machines

Each Linux machine that takes part in the Shield cluster must be prepared before creating the cluster.
Please follow these steps and perform them on each machine separately:

Configure OS settings:

```bash
curl -s -o configure-sysctl-values.sh https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Rel-19.07.1/Kube/scripts/configure-sysctl-values.sh
chmod +x configure-sysctl-values.sh
sudo ./configure-sysctl-values.sh
```

Install Docker:

```bash
curl -s -o install-docker.sh https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Rel-19.07.1/Kube/scripts/install-docker.sh
chmod +x install-docker.sh
./install-docker.sh
```

```bash
sudo usermod -aG docker "$USER"
```
Logout and login again.

Verify that Docker is installed properly:

```bash
docker version 
```
 
All the machines should be in the same timezone. The recommendation is to configure the machines using NTP (Network Time Protocol).
To do so, follow these steps. Run:

```bash
yum install ntp
systemctl start ntp
systemctl enable ntp
```

Repeat these steps for each machine in the system. 

Verify that all machines have: Static IP, unique hostname and are on the same timezone.

## Deploying Shield Browser Farm Locally

It is recommended to have, a dedicated machine to run Rancher and Kubectl/Helm Services in order to create the cluster and deploy Shield on it. This machine will be referred to as the **Rancher Server**.

### Create A Cluster On Rancher

Note: Rancher is a well-known software platform that enables easy deployment and management of Docker and Kubernetes products in production.  installed on a cluster machine but the default ports will have to be changed.

Install Rancher and create a Kubernetes cluster using these instructions:

[Rancher](https://github.com/EricomSoftwareLtd/Shield/blob/Dev/Kube/Rancher-README.md)

### Set Nodes Labels

According to the planned deployment, set the node labels for each machine:

In Rancher, select ``Nodes`` and for each node you wish to edit, select the ``Edit`` option from the menu on the right
In the ``Edit Node`` dialog, expand the ``Labels`` section and add the desired labels to the node. For each label, set the value **accept**.

The possible labels are:

you can copy/paste one or more lines of labels below:

shield-role/management=accept
shield-role/proxy=accept
shield-role/elk=accept
shield-role/farm-services=accept
shield-role/remote-browsers=accept

Press ``Save``. The updated labels now appear on the node details.

The Kubernetes cluster is now up and ready to deploy Shield on it.

### Install Kubectl

Note: If you are using Shield-OVA, kubectl is already installed, so you can skip this step and continue to: **Update ~/.kube/config with Kubeconfig**

Kubectl is used for running commands on Kubernetes clusters. For more details, see [here] (<https://kubernetes.io/docs/reference/kubectl/overview/>).

Install Kubectl on the first machine, where Rancher is installed (the Linux Master). Run these commands:

```bash
curl -s -o install-kubectl.sh https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Rel-19.07.1/Kube/scripts/install-kubectl.sh
chmod +x install-kubectl.sh
./install-kubectl.sh
```

### Update ~/.kube/config with Kubeconfig

* In Rancher, click on the Cluster, then on ``Kubeconfig File`` option (on the right). Scroll down and select the ``Copy to Clipboard`` option.
* On the Linux machine, create a directory named `~/.kube` (mkdir ~/.kube) then create a file named ``~/.kube/config`` and paste clipboard content to the file.

Once the file is created, check that kubectl is configured properly (client and server):

``kubectl version``

The expected outcome should be something like:

```bash
Client Version: version.Info{Major:"1", Minor:"14", GitVersion:"v1.14.3", GitCommit:"5e53fd6bc17c0dec8434817e69b04a25d8ae0ff0", GitTreeState:"clean", BuildDate:"2019-06-06T01:44:30Z", GoVersion:"go1.12.5", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"13", GitVersion:"v1.13.5", GitCommit:"2166946f41b36dea2c4626f90a77706f426cdea2", GitTreeState:"clean", BuildDate:"2019-03-25T15:19:22Z", GoVersion:"go1.11.5", Compiler:"gc", Platform:"linux/amd64"}
```

### Install Helm

Helm is an application manager, used to run applications on Kubernetes (e.g., Shield). It is recommended to install Helm on the same machine that includes Rancher & Kubectl (Rancher Server machine).

Note: If you are using Shield-OVA, helm is already installed so no need to copy it locally. Do run the script itself (./install-helm.sh) to initialize Helm

```bash
curl -s -o install-helm.sh https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Rel-19.07.1/Kube/scripts/install-helm.sh
chmod +x install-helm.sh
./install-helm.sh
```

Check that helm is configured properly (client and server):

``helm version``

The expected outcome should be something like:

```bash
Client: &version.Version{SemVer:"v2.14.1", GitCommit:"5270352a09c7e8b6e8c9593002a73535276507c0", GitTreeState:"clean"}
Server: &version.Version{SemVer:"v2.14.1", GitCommit:"5270352a09c7e8b6e8c9593002a73535276507c0", GitTreeState:"clean"}
```

### Add Shield Repository

Note: Shield repository requires a valid password. Please contact Shield Professional Services team to get one.

Note: If you are using Shield-OVA, helm is already installed so no need to copy it locally. Skip this step and continue to verify the repository.

```bash
curl -s -o add-shield-repo.sh  https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Rel-19.07.1/Kube/scripts/add-shield-repo.sh
chmod +x add-shield-repo.sh
./add-shield-repo.sh -p PASSWORD
```

Verify that your repository is properly configured by running

```bash
helm search shield
```

The result should be something like:

![image](https://user-images.githubusercontent.com/24224420/59362670-8a56a880-8d3c-11e9-9b68-754f726177eb.png)

### Deploy Shield

Note: deploy-shield script is provided as an example on how to deploy the system in an all-in-one deployment
For a more complex deployment, the node labels must be set on each node according to the desired deployment, then Shield should be deployed using Helm.

```bash
curl -s -o deploy-shield.sh https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Rel-19.07.1/Kube/scripts/deploy-shield.sh
chmod +x deploy-shield.sh
./deploy-shield.sh
```

### Move Shield-Services To Default Project

In Rancher, click on the cluster.
Then click on Projects/Namespaces
Select the Shield components (management, proxy, farm-services, elk) and click on the ``Move`` option on top.
Select **Default** and confirm. The Shield components are now displayed under the Default project.

![image](https://user-images.githubusercontent.com/24224420/59365676-9e50d900-8d41-11e9-97bb-8d088ef63b89.png)

Now, click on your Cluster (close to the Rancher Icon) and select Default under your Cluster Name

![image](https://user-images.githubusercontent.com/24224420/59365822-e3750b00-8d41-11e9-8483-801a5fea47fb.png)

When you see under ``Workloads`` that the system is up and running (or by running helm status shield), your system is ready.

To connect to Shield on the Proxy Port, connect to the Host IP where the Shield-Proxy Component is running on **3128** port.
To connect to Shield Admin Console, connect to the Host IP where the Admin is running and use port **30181**. 
