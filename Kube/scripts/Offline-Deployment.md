# Fresh Installation

1. Download and start the [Offline Registry VM](https://shield-ova.s3.amazonaws.com/shield-kube-rel-20.03-registry.ova); write down its address. Docker registry will be available on port 5000;
2. On the node which you are going to use for Rancher, `export ES_OFFLINE_REGISTRY="<Offline Registry VM Address>:5000"`;
3. Download https://github.com/EricomSoftwareLtd/Shield/releases/download/shield-prepare-servers-Rel-20.03/shield-prepare-servers and make it executable: chmod +x  shield-prepare-servers;
4. Run `./shield-prepare-servers -u <USER> --offline-mode --offline-registry "$ES_OFFLINE_REGISTRY" <NODE1> <NODE2> …` (e.g. `./shield-prepare-servers -u ericom --offline-mode --offline-registry "192.168.56.1:5000" 192.168.56.101`) This will configure Docker on all nodes to use the Offline Registry VM;
5. Navigate to a directory where you have local Shield Helm charts (usually located at /home/ericom/ericomshield/shield-repo);
6. Run `./shield-prepare-servers add-registry "$ES_OFFLINE_REGISTRY" shield-repo/shield/values.yaml shield-repo/shield/charts/consul/values.yaml` This will update the Helm chars to use the  Offline Registry VM;
7. Create Shield cluster and deploy Shield as usual.

# Upgrading an Existing Shield Installation

1. Download and start the [Offline Registry VM](https://shield-ova.s3.amazonaws.com/shield-kube-rel-20.03-registry.ova); write down its address. Docker registry will be available on port 5000;
2. Kill the running Rancher instance (use `docker ps | grep "rancher/rancher:"` to find it);
3. Run `export ES_OFFLINE_REGISTRY="<Offline Registry VM Address>:5000"`;
4. Run `./shield-prepare-servers -u <USER> --offline-mode --offline-registry "$ES_OFFLINE_REGISTRY" <NODE1> <NODE2> …` This will configure Docker on all nodes to use the Offline Registry VM. Note that the Rancher node needs to be reconfigured too;
5. Restart Rancher by running the run-rancher.sh script (make sure the ES_OFFLINE_REGISTRY is exported);
6. Open the Rancher UI and edit cluster settings; ![Screenshot 2020-04-02 at 14 23 52](https://user-images.githubusercontent.com/11456918/78457741-19aabf00-76b5-11ea-8549-1b5b91a238aa.png)
7. Choose the latest Kubernetes version; ![Screenshot 2020-04-02 at 14 24 36](https://user-images.githubusercontent.com/11456918/78457742-1b748280-76b5-11ea-84fe-33c1c4f67990.png)
8. Update the cluster by clicking "Save"; ![Screenshot 2020-04-02 at 14 25 08](https://user-images.githubusercontent.com/11456918/78457745-1ca5af80-76b5-11ea-90f5-0c80929ec5ad.png)
9. Navigate to a directory where you have local Shield Helm charts (a copy of https://github.com/EricomSoftwareLtd/Kube/tree/Dev/shield inside a directory usually named shield-repo);
10. Run `./shield-prepare-servers add-registry "$ES_OFFLINE_REGISTRY" shield-repo/shield/values.yaml shield-repo/shield/charts/consul/values.yaml` This will update the Helm chars to use the  Offline Registry VM;
11. Run `deploy-shield.sh`. This will update Shield.
