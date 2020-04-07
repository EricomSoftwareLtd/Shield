#! /bin/bash  -e
HELM_VERSION=v3.1.2

echo "###################################################################################"
echo "##this script will download helm3, and migrate existing charts into it.          ##"
echo "##it will also remove helm2 from machine and replace it with helm3!!!            ##"
echo "##this cant be reverted!!!                                                       ##"
echo "##please run with --dry-run flag to see the output before running it correctly.. ##"
echo "## migrate2to3.sh --dry-run                                                      ##"
echo "##you have 20 seconds to abort...                                                ##"
echo "###################################################################################"
sleep 20

if [ "$1" == "--dry-run" ]; then
    dryrun="$1"
fi
which helm3
if [ $? -ne 0 ]; then
    echo "installing helm3..."
    curl -LO https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz 
    tar -zvxf ./helm-${HELM_VERSION}-linux-amd64.tar.gz 
    mv ./linux-amd64/helm /usr/bin/helm3
else
    echo "skipping install..."
    echo "helm3 already present at $(which helm3)..."
fi

if [ $(helm3 plugin list | grep -o "2to3") ]; then
    echo "2to3 plugin already present.."
else 

    echo "installing helm3 plugin 2to3..."
    echo "it might take a while..."
    helm3 plugin install https://github.com/helm/helm-2to3/
fi

echo "migrating chart staters, repositories and plugins... $dryrun"
echo 'y'| helm3 2to3 move config $dryrun
sleep 1

echo "converting running charts to helm3... $dryrun"
helm list | awk '{print $1}' | tail -n +2 | xargs -L1 helm3 2to3 convert --delete-v2-releases $dryrun

echo "helm 3 chart list:"
helm3 list --all-namespaces

echo "changing between binaries $dryrun"
if [ "$dryrun" == "--dry-run" ]; then
    :
else
    helm3 repo update
    helmpath=$(which helm)
    sudo rm -rf $helmpath
    sudo mv $(which helm3) $helmpath
fi