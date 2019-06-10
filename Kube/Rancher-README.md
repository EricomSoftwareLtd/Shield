# Ericom Shield (K8s) Readme

Welcome! This repository houses all of the assets required to deploy Ericom Shield on Kubernetes
We're very pleased that you want to contribute!

## Deploying Rancher On Prem

### 1. Deploy Rancher

* Create directory for save data:
`mkdir -p ./rancher-store`

* Run rancher

```bash

  docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  -v /home/[ your linux user]/rancher-store:/var/lib/rancher \
  rancher/rancher:latest
```

### 2. Init your Rancher

* Open your favorite browser and go to <https://localhost>. You should see this screen:
![Login screen](https://user-images.githubusercontent.com/26378199/48976764-8f505500-f095-11e8-8228-cf85c1d0a1a0.png)
Enter administrator password and click Continue

![Save URL](https://user-images.githubusercontent.com/26378199/48976784-274e3e80-f096-11e8-95be-c0c4c85ef680.png)

Click "Save URL"

![Start page](https://user-images.githubusercontent.com/26378199/48976795-595fa080-f096-11e8-9495-289a104aaf16.png)

### 3. Create your Cluster

Click "Add Cluster"

Choose Custom, add name and click Next
![Custom](https://user-images.githubusercontent.com/26378199/48976807-8f048980-f096-11e8-9e1b-406d06fbb488.png)

Fill all check boxes and copy text in black field, after this click Done

![Text ](https://user-images.githubusercontent.com/26378199/48976838-f0c4f380-f096-11e8-865a-392b2e783aec.png)

Run copied command in terminal, sit back and wait when cluster be ready  

Make sure to set the docker hub registry
