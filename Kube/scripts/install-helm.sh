#!/bin/bash
############################################
#####   Ericom Shield Installer:Helm   #####
#######################################BH###
APP="Helm"

function usage() {
    echo " Usage: $0 "
}

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    usage
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

helm_init() {
 kubectl -n kube-system create serviceaccount tiller
 kubectl create clusterrolebinding tiller \
    --clusterrole cluster-admin \
    --serviceaccount=kube-system:tiller
 kubectl create -f rbac-config.yaml
 helm init --service-account=tiller
 kubectl create rolebinding default-view --clusterrole=view --serviceaccount=kube-system:default --namespace=kube-system
 kubectl create clusterrolebinding add-on-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default
}
helm_clean() {
 kubectl -n kube-system delete deployment tiller-deploy
 kubectl delete clusterrolebinding tiller
 kubectl -n kube-system delete serviceaccount tiller
}

if [ ! -x /usr/local/bin/helm ]; then
   echo "Installing $APP ..."
   curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
   chmod +x get_helm.sh

   ./get_helm.sh -v v2.14.1
   source <(helm completion bash)
   echo "Done!"
 else
  echo "$APP is already installed"
fi

echo "Init tiller"
helm_clean
helm_init

echo "Done!"
