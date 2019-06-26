# Ericom Shield (K8s) Readme

Welcome! This repository houses all of the assets required to deploy Ericom Shield on Kubernetes
We're very pleased that you want to contribute!

## Deploying Rancher On Prem

### 1. Deploy Rancher

Docker is required to deploy Rancher. If Docker is not installed - install it using these instructions:

```bash
curl -s -o install-docker.sh https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Staging/Kube/scripts/install-docker.sh
chmod +x install-docker.sh
sudo ./install-docker.sh
```

Verify that Docker is installed properly:
  
`sudo docker version`

* Create a directory to save data:

`mkdir -p ~/rancher-store`

* Run Rancher

```bash
sudo docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  -v ~/rancher-store:/var/lib/rancher \
  rancher/rancher:latest
```
Note: If Rancher is running on the same server where Shield will be deployed, the published ports (left side), should be changed.

### 2. Init your Rancher

* Open your favorite browser and go to <https://RancherServerIPAddress>. You should see this screen:
![Login screen](https://user-images.githubusercontent.com/26378199/48976764-8f505500-f095-11e8-8228-cf85c1d0a1a0.png)
Enter administrator password and click ``Continue``

![rancherURL](https://user-images.githubusercontent.com/24224420/59359193-917ab800-8d36-11e9-8f68-4d5c66774a31.png)

Click ``Save URL``

### 3. Create your Cluster

Click ``Add Cluster``

- Choose Custom (right hand side, under ``Import``)

![Custom](https://user-images.githubusercontent.com/26378199/48976807-8f048980-f096-11e8-9e1b-406d06fbb488.png)

- Fill in the ``Cluster Name`` as desired
- On the ``Network Provider`` select the **Calico** option 
- Click ``Next``

Mark all the check boxes and copy the command (text in black box). 

![Text ](https://user-images.githubusercontent.com/26378199/48976838-f0c4f380-f096-11e8-865a-392b2e783aec.png)

### 4. Add Node/s To Your Cluster

For all nodes that will be member of your cluster  that will be added to an existing cluster, follow these steps:

**Configure OS Settings**

```bash
      curl -s -o configure-sysctl-values.sh https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Staging/Kube/scripts/configure-sysctl-values.sh
      sudo chmod +x configure-sysctl-values.sh
      sudo ./configure-sysctl-values.sh
```

**Install Docker**

```bash
curl -s -o install-docker.sh https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Staging/Kube/scripts/install-docker.sh
sudo chmod +x install-docker.sh
sudo ./install-docker.sh
```

**Join Nodes to the Cluster**

From the Rancher Windows, Click on the "Copy To Clipboard" Button
Run the copied command on all nodes that will be members of the Shield cluster. Wait until the cluster is ready.
After the cluster is ready, a green message appears in the bottom of the page. Click ``Done``.

The Kubernetes cluster is now up and ready to deploy Shield on it.
