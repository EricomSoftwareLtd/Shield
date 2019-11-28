*Setting Up a High Availability Cluster*

1. Prepare at least four nodes running CentOS 7 (or Ubuntu 18.04). Refer to https://rancher.com/docs/rancher/v2.x/en/installation/requirements/ for Rancher node requirements. Refer to the corresponding Shield documentation for Shield node requirements; also prepare one workstation;
1. At least one node should be reserved for load-balancing proxy acting as a gateway to the Rancher Cluster (minimum amount of memory and CPU resources is required for this type of node(s));
1. Make sure you have a separate Linux workstation with an SSH client, ssh-keygen and ssh-copy-id programs. This is further referred to as administrator’s workstation;
1. Make sure you have a working local Domain Name System that you can control (for production installations only, it is not necessary for testing);
1.
    1. Clone the repository with Shield scripts `git clone --branch SHIELD-4086-Rancher-HA --single-branch https://github.com/EricomSoftwareLtd/Shield.git && cd Shield/Kube/scripts/RKE`;
    1. Download or install on the administrator’s workstation the latest stable versions of kubectl (https://kubernetes.io/docs/tasks/tools/install-kubectl/), helm 2 (e.g. https://github.com/helm/helm/releases/tag/v2.16.1), and RKE (https://rancher.com/docs/rke/latest/en/installation/#download-the-rke-binary save the binary in the directory containing the RKE scripts as rke_linux-amd64);
1. Install Docker on all nodes (use shield-prepare-nodes from the administrator’s workstation to prepare CentOS 7 nodes);
1. Make sure all the nodes have a user belonging to group “docker” (run “sudo usermod -aG docker $USER” on all nodes to add this user to the group);
1. Make sure all the nodes are accessible via SSH under this user’s account from the administrator’s workstation using SSH public keys (use ssh-keygen and ssh-copy-id to generate a key pair and distribute the public key across all nodes)
1. Run generate_ca.sh (obtained at step 5.i) or copy and save your existing CA certificate and key as cacerts.pem and cacerts.key respectively;
1. Run generate_cert.sh to generate a certificate to be used bu the Runcher cluster;
1. Create a record in your DNS to point to the node (or nodes) reserved for a load balancer (use the xip.io service for testing: prepend the load balancer IP address to .xip.io; 10.99.74.194.xip.io is used in this example);
1. Edit the file named “common”, set RANCHER_LB_HOSTNAME="10.99.74.194.xip.io" (or use the FQDN record from your DNS);
1. Edit rancher-cluster.yml, replace 10.99.74.194 with the IP address of your load balancer (copy this section to add additional load balancers);
1. Replace addresses in other sections with the addresses of non-load balancer nodes reserved for your cluster (add or remove these sections as needed), add regular worker nodes with role: [worker] only (do not add the “system-role/ingress-rancher: accept” label to these nodes – this is for the Rancher load balancers only);
1. Replace “ericom” in user: ericom with the user from step 8.
1. Run 0_rke_up.sh. Make sure there are no errors;
1. Run 1_install_tiller.sh. Make sure there are no errors;
1. Run 2_deploy_rancher.sh. Make sure there are no fatal errors (“Error from server (NotFound): secrets "tls-ca" not found” and the likes are OK);
1. Head over to https://<RANCHER_LB_HOSTNAME>:8443 in your browser. Follow the instructions. Make sure Rancher works fine, “local” cluster is imported and functions with no errors;
1. Copy kube_config_rancher-cluster.yml to “~/.kube/config”(cp kube_config_rancher-cluster.yml ~/.kube/config) and proceed to regular Shield installation procedure (past Rancher installation and cluster creation);
