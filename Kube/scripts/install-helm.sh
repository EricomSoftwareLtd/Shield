#!/bin/bash
############################################
#####   Ericom Shield Installer:Helm   #####
#######################################BH###
APP="Helm"
APP_VERSION="v3.1.2"
APP_BIN="helm"
ES_FORCE=false
ES_CLEAN=false
ES_INIT=false

if [ ! -z "${ES_OFFLINE_REGISTRY}" ]; then
    ES_OFFLINE_REGISTRY_PREFIX="${ES_OFFLINE_REGISTRY}/"
fi
ES_TILLER_IMAGE="${ES_OFFLINE_REGISTRY_PREFIX}gcr.io/kubernetes-helm/tiller:${APP_VERSION}"

function usage() {
    echo " Usage: $0 [-f|--force] [-c|--clean] [-h|--help] [--print-docker-images]"
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
    --print-docker-images)
        echo "${ES_TILLER_IMAGE}"
        exit
        ;;
    esac
    shift
done



if ! which "$APP_BIN" >/dev/null || [ $ES_FORCE == true ]; then
    echo "Installing $APP ..."
    curl -fsSL https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get -o /tmp/get_helm.sh
    sudo chmod +x /tmp/get_helm.sh
    sudo /tmp/get_helm.sh -v "$APP_VERSION"
    rm -f /tmp/get_helm.sh
    source <(helm completion bash)
    echo "Helm has been installed"
else
    echo "$APP is already installed"
fi


helm version

echo "Done!"
