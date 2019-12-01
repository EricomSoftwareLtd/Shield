#!/bin/bash
############################################
#####   Ericom Shield Installer:Kubectl  ###
#######################################BH###
APP="Kubectl"
APP_BIN="kubectl"
ES_FORCE=false

if [ -f /etc/redhat-release ]; then
    OS="RHEL"
else
    OS="Ubuntu"
fi

function usage() {
    echo " Usage: $0 "
}

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -f | --force)
        ES_FORCE=true
        ;;
    -h | --help)
#    *)
        usage
        exit
        ;;
    esac
    shift
done

if ! which "$APP_BIN" >/dev/null || [ $ES_FORCE == true ]; then
    echo "Installing $APP ..."

    if ! [ -d "${HOME}/.kube" ]; then
        mkdir -p "${HOME}/.kube"
        touch "${HOME}/.kube/config"
    fi

    if [[ $OS == "Ubuntu" ]]; then
        sudo apt-get update &&
            sudo apt-get install -y apt-transport-https
        curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
        echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
        sudo apt-get update
        sudo apt-get install -y kubectl
    elif [[ $OS == "RHEL" ]]; then
        sudo tee -a /etc/yum.repos.d/kubernetes.repo <<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
        sudo yum install -y kubectl
    fi

    # kubectl completion bash
    source <(kubectl completion bash)
    echo "Done!"

    kubectl version --short --client

else
    echo "$APP is already installed"
    kubectl version --short --client
fi
