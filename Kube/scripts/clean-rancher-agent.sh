#!/bin/bash
################################################
#####   Ericom Shield: Cleaner             #####
###########################################BH###
ES_ALL=false
ES_PATH="$HOME/ericomshield"
ES_RANCHER_STORE="$ES_PATH/rancher-store"

function usage() {
    echo " Usage: $0 [-a|--all] [-h|--help]"
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
    -a | --all)
        ES_ALL=true
        ;;
    #    -h | --help)
    *)
        usage
        exit
        ;;
    esac
    shift
done

echo
echo "This script will cleanup Rancher (and any other container running on this node"
echo "Abort the script with 'Ctrl c' if this is not what you want to do (5s)"
echo
sleep 5

docker rm -f $(docker ps -qa)
docker volume rm $(docker volume ls -q)
cleanupdirs="/var/lib/etcd /etc/kubernetes /etc/cni /opt/cni /var/lib/cni /var/run/calico /var/run/flannel /opt/rke $ES_RANCHER_STORE $HOME/.helm"
for dir in $cleanupdirs; do
    echo "Removing $dir"
    rm -rf $dir
done
if [ "$ES_ALL" == "true" ]; then
    docker system prune -a -f
fi

rm -f ~/.kube/config

echo "Please reboot your system, to cleanup the machine"
echo
sleep 5
