# Fresh Installation

1. Download and start the [Offline Registry VM](https://shield-ova.s3.amazonaws.com/shield-kube-rel-20.03-registry.ova); write down its address. Docker registry will be available on port 5000;
2. Connect to the OVA via SSH as ericom (the password is ericomshield);
3. `cd ericomshield; export ES_OFFLINE_REGISTRY="<Offline Registry VM Address>":5000`;
4. Run `./shield-prepare-servers -u <USER> --offline-mode --offline-registry $ES_OFFLINE_REGISTRY <NODE1> <NODE2> …`  (e.g. `./shield-prepare-servers -u ubuntu --offline-mode --offline-registry 10.100.200.153:5000 10.100.200.96`) This will configure Docker on all nodes to use the Offline Registry VM;
5. Login to one of the configured nodes where you are going to run Rancher (Master-Node);
6. Download `install-shield-from-container.sh` from `http://<Offline Registry VM Address>/ericomshield/install-shield-from-container.sh` (e.g. `wget http://10.100.200.153/ericomshield/install-shield-from-container.sh`, you may also download it using scp from `ericom@<Offline Registry VM Address>:~/ericomshield/install-shield-from-container.sh`); run `chmod +x install-shield-from-container.sh`;
7. Run `./install-shield-from-container.sh --version <VERSION> --registry <Offline Registry VM Address>:5000` <br />
(e.g. `./install-shield-from-container.sh --version Rel-20.03.641 --registry 10.100.200.153:5000`); <br />
(use -l if you want to set all the labels)
8. Add other nodes to the cluster as usual.

Note: If you receive the error:<br />
_apt cache update failed_ <br /> 
Then execute the following to clean the apt cache: <br />
`sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak` <br />
`sudo touch /etc/apt/sources.list` <br />
`sudo apt update` <br />

# Upgrading an Existing Shield Installation

! NOTE: Do not use `sudo` unnecessarily ! 

1. Download and start the [Offline Registry VM](https://shield-ova.s3.amazonaws.com/shield-kube-rel-20.03-registry.ova); write down its address. Docker registry will be available on port 5000;
2. Go to the Master-Node and kill the running Rancher instance (use `docker ps | grep "rancher/rancher:"` to find it);
3. Run `export ES_OFFLINE_REGISTRY="<Offline Registry VM Address>:5000"`;
4. Run `./shield-prepare-servers -u <USER> --offline-mode --offline-registry "$ES_OFFLINE_REGISTRY" <NODE1> <NODE2> …` This will configure Docker on all nodes to use the Offline Registry VM. Note that the Rancher node needs to be reconfigured too;
4.1. Run `sudo systemctl reload docker`;
5. Restart Rancher by running the run-rancher.sh script (make sure the ES_OFFLINE_REGISTRY is exported by running `echo $ES_OFFLINE_REGISTRY`);
6. Open the Rancher UI and edit cluster settings; ![Screenshot 2020-04-02 at 14 23 52](https://user-images.githubusercontent.com/11456918/78457741-19aabf00-76b5-11ea-8549-1b5b91a238aa.png)
7. Choose the latest Kubernetes version; ![Screenshot 2020-04-02 at 14 24 36](https://user-images.githubusercontent.com/11456918/78457742-1b748280-76b5-11ea-84fe-33c1c4f67990.png)
8. Update the cluster by clicking "Save"; ![Screenshot 2020-04-02 at 14 25 08](https://user-images.githubusercontent.com/11456918/78457745-1ca5af80-76b5-11ea-90f5-0c80929ec5ad.png)
9. Navigate to a directory where you have local Shield Helm charts (a copy of https://github.com/EricomSoftwareLtd/Kube/tree/Dev/shield inside a directory usually named shield-repo or ericomshield);
10. Run `./shield-prepare-servers add-registry "$ES_OFFLINE_REGISTRY" ./shield` This will update the Helm charts to use the  Offline Registry VM;
11. Run `./install-shield-from-container.sh --version <NEW_VERSION> --registry <Offline Registry VM Address>:5000` <br />
(e.g. `./install-shield-from-container.sh --version Rel-20.03.642 --registry 10.100.200.153:5000`); <br />
