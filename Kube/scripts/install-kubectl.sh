#!/bin/bash
############################################
#####   Ericom Shield Installer:Kubectl  ###
#######################################BH###
APP="Kubectl"
APP_BIN="/usr/local/bin/kubctl"
ES_FORCE=false

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

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -f | --force)
        ES_FORCE=true
        ;;
    #    -h | --help)
    *)
        usage
        exit
        ;;
    esac
    shift
done

if [ ! -x "$APP_BIN" ] || [ $ES_FORCE ]; then
   echo "Installing $APP ..."
   mkdir -p ~/.kube

   apt-get update && apt-get install -y apt-transport-https
   curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
   echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
   apt-get update
   apt-get install -y kubectl
   kubectl completion bash
   source <(kubectl completion bash)
   echo "Done!"
  
   kubectl version --short --client

  else
  echo "$APP is already installed"
  kubectl version --short --client
fi
