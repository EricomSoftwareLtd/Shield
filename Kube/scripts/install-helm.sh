#!/bin/bash
############################################
#####   Ericom Shield Installer:Helm   #####
#######################################BH###
APP="Helm"
APP_VERSION="v2.14.3"
APP_BIN="helm"
ES_FORCE=false
ES_CLEAN=false
ES_INIT=false
BRANCH="master"

function usage() {
    echo " Usage: $0 [-f|--force] [-c|--clean] [-h|--help]"
}

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -i | --init)
        ES_INIT=true
        ;;
    -f | --force)
        ES_FORCE=true
        ;;
    -c | --clean)
        ES_CLEAN=true
        ;;
    -h | --help)
        #    *)
        usage
        exit
        ;;
    esac
    shift
done

helm_init() {
    if ! [ -f rbac-config.yaml ]; then
        curl -s -o rbac-config.yaml "https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/rbac-config.yaml"
    fi
    kubectl -n kube-system create serviceaccount tiller
    kubectl create clusterrolebinding tiller \
        --clusterrole cluster-admin \
        --serviceaccount=kube-system:tiller
    kubectl create -f rbac-config.yaml
    helm init --upgrade --wait --service-account=tiller
    kubectl create rolebinding default-view --clusterrole=view --serviceaccount=kube-system:default --namespace=kube-system
    kubectl create clusterrolebinding add-on-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default
}

helm_clean() {
    kubectl -n kube-system delete deployment tiller-deploy
    kubectl delete clusterrolebinding tiller
    kubectl -n kube-system delete serviceaccount tiller
}

if ! which "$APP_BIN" >/dev/null || [ $ES_FORCE == true ]; then
    echo "Installing $APP ..."

    curl -fsSL https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get -o /tmp/get_helm.sh
    chmod +x /tmp/get_helm.sh
    sudo /tmp/get_helm.sh -v "$APP_VERSION"
    rm -f /tmp/get_helm.sh

    source <(helm completion bash)

    docker pull "gcr.io/kubernetes-helm/tiller:$APP_VERSION"

    echo "Helm has been installed"
    ES_INIT=true
else
    echo "$APP is already installed"
fi

if [ "$ES_CLEAN" == true ]; then
    echo "Clean tiller"
    helm_clean
    ES_INIT=true
fi

if [ "$ES_INIT" == true ]; then
    echo "Init tiller"
    helm_init
fi

# wait 5 secs to let tiller starting
sleep 5

helm version

echo "Done!"
