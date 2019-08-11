# Ericom Shield (K8s) Readme

## Deploying Rancher On Prem

### Deploy Rancher

* Run Rancher

```bash
curl -s -o run-rancher.sh https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Staging/Kube/scripts/run-rancher.sh
chmod +x run-rancher.sh
./run-rancher.sh
```

### Init your Rancher

* Open your favorite browser and go to <https://RancherServerIPAddress:8443>. You should see this screen:
![Login screen](https://user-images.githubusercontent.com/26378199/48976764-8f505500-f095-11e8-8228-cf85c1d0a1a0.png)
Enter administrator password and click ``Continue``

![rancherURL](https://user-images.githubusercontent.com/24224420/59359193-917ab800-8d36-11e9-8f68-4d5c66774a31.png)

Click ``Save URL``

### Create your Cluster

Click ``Add Cluster``

-Choose Custom (right hand side, under ``Import``)

![Custom](https://user-images.githubusercontent.com/26378199/48976807-8f048980-f096-11e8-9e1b-406d06fbb488.png)

-Fill in the ``Cluster Name`` as desired
-On the ``Network Provider`` select the **Calico** option
-Click ``Next``

Mark all the check boxes and copy the command (text in black box).

![Text ](https://user-images.githubusercontent.com/26378199/48976838-f0c4f380-f096-11e8-865a-392b2e783aec.png)

### Add Node/s To Your Cluster

From the Rancher Windows, Click on the "Copy To Clipboard" Button

Run the copied command on EACH Linux machine to join it to the cluster. Make sure the copied command matches the 
node to join (**Master**/**Worker**). Follow the node joining by clicking on ``Nodes`` in the cluster menu.

Wait until the process is finished. After the node is joined to the cluster, a green message appears at the bottom of the page. 
Repeat this process per each node until the cluster is complete. Click ``Done``.
