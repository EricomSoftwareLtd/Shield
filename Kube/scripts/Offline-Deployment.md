# Shield Offline Deployment

## Fresh Installation

1. Download and start the [Offline Registry VM](https://shield-ova.s3.amazonaws.com/shield-kube-rel-20.03-registry.ova); write down its address. Docker registry will be available on port 5000;
2. Connect to the Offline registry VM via SSH as ericom (the password is ericomshield);
3. `cd ericomshield; 
4. Run `./shield-prepare-servers -u <USER> --offline-mode --offline-registry <Offline registry vm address>:5000 <NODE1> <NODE2> …`  (e.g. `./shield-prepare-servers -u ubuntu --offline-mode --offline-registry 10.100.200.153:5000 10.100.200.96`) This will configure Docker on all nodes to use the Offline Registry VM;
5. Login to one of the configured nodes where you are going to run Rancher (Master-Node);
6. backup if needed `install-shield-from-container.sh` under ericomshield folder.
   copy `install-shield-from-container.sh` from ova registry machine:;
   Download `install-shield-from-container.sh` from `http://<Offline Registry VM Address>/ericomshield/install-shield-from-container.sh` (e.g. `wget http://10.100.200.153/ericomshield/install-shield-from-container.sh`, you may also download it using scp from `ericom@<Offline Registry VM Address>:~/ericomshield/install-shield-from-container.sh`); run `chmod +x install-shield-from-container.sh`;
7. Run `sudo ./install-shield-from-container.sh --version <VERSION> --registry <Offline Registry VM Address>:5000`  
(e.g. `sudo ./install-shield-from-container.sh --version Rel-20.03.641 --registry 10.100.200.153:5000`);  
(use -l if you want to set all the labels)
8. Add other nodes to the cluster as usual.

Note for step 4:
If you receive the error:  
_apt cache update failed_  
Then execute the following to clean the apt cache:  
`sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak`  
`sudo touch /etc/apt/sources.list`  
`sudo rm /etc/apt/sources.list.d/*` (or backup the files)
`sudo apt update`  

## Upgrading an Existing Shield Installation

**NOTE: Do not use `sudo` unnecessarily** 

1. Download and start the [Offline Registry VM](https://shield-ova.s3.amazonaws.com/shield-kube-rel-20.03-registry.ova); write down its address. Docker registry will be available on port 5000;
2. Go to the Master-Node and kill the running Rancher instance (use `docker ps | grep "rancher/rancher:"` to find it);
3. Go to Offline registry VM Run `./shield-prepare-servers -u <USER> --offline-mode --offline-registry <offline registry vm address>:5000 <NODE1> <NODE2> …` This will configure Docker on all nodes to use the Offline Registry VM. Note that the Rancher node needs to be reconfigured too;
3.1. Run `sudo systemctl reload docker`;
4. on shield machine with Rancher (master node):
    backup run-rancher.sh
    copy run-rancher.sh from registry ova machine:
    (e.g: `wget http://10.100.200.153/ericomshield/run-rancher.sh` or using csp command:
    scp ericom@<Offline Registry VM Address>:/home/ericom/ericomshield/run-rancher.sh /home/ericom/ericomshield)
    Run  `export ES_OFFLINE_REGISTRY="<Offline Registry VM Address>:5000"`; 
    make sure the ES_OFFLINE_REGISTRY is exported by running `echo $ES_OFFLINE_REGISTRY`);
    run ./run-rancher.sh;  (see note about it beneath)
5. Open the Rancher UI and edit cluster settings; ![Screenshot 2020-04-02 at 14 23 52](https://user-images.githubusercontent.com/11456918/78457741-19aabf00-76b5-11ea-8549-1b5b91a238aa.png)
7. Choose the latest Kubernetes version; ![Screenshot 2020-04-02 at 14 24 36](https://user-images.githubusercontent.com/11456918/78457742-1b748280-76b5-11ea-84fe-33c1c4f67990.png)
8. Update the cluster by clicking "Save"; ![Screenshot 2020-04-02 at 14 25 08](https://user-images.githubusercontent.com/11456918/78457745-1ca5af80-76b5-11ea-90f5-0c80929ec5ad.png);
   
9. backup if needed `install-shield-from-container.sh` under ericomshield folder;
  Download `install-shield-from-container.sh` from `http://<Offline Registry VM Address>/ericomshield/install-shield-from-  container.sh` (e.g. `wget http://10.100.200.153/ericomshield/install-shield-from-container.sh`, you may also download it using scp from `ericom@<Offline Registry VM Address>:~/ericomshield/install-shield-from-container.sh`); run `chmod +x install-shield-from-container.sh`;
   Run `sudo ./install-shield-from-container.sh --version <NEW_VERSION> --registry <Offline Registry VM Address>:5000`  
(e.g. `./install-shield-from-container.sh --version Rel-20.03.642 --registry 10.100.200.153:5000`);


note:
when copy files from registry to shield machine, make sure the permissions are correct and the owner is the correct (ericom)
if not change as needed
example:
`chown ericom run-rancher.sh`;
will change the owner to ericom if needed.;
need to run it without sudo.;
