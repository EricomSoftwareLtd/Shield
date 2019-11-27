#!/bin/bash
############################################
#####   Ericom Shield Delete Shield   #####
#######################################BH###

SHIELD="shield"
ES_SILENT=false
ES_CONF=false
ES_DELETE_NAMESPACE=true

COMPONENTS=(farm-services proxy management elk common)

function usage() {
    echo " Usage: $0 [-n|--namespace <NAMESPACE>] [-s|--silent] [-k|--keep-namespace] [-h|--help]"
    echo
    echo "    namespaces: shield-management, shield-proxy, shield-farm, shield-elk"
}

function log_message() {
    local PREV_RET_CODE=$?
    echo "$@"
    echo "$(LC_ALL=C date): $@" >>"$LOGFILE"
    if ((PREV_RET_CODE != 0)); then
        return 1
    fi
    return 0
}

only_namespace() {
    case "$1" in
    shield-management)
        COMPONENTS=(management)
        ;;
    shield-proxy)
        COMPONENTS=(proxy)
        ;;
    shield-farm)
        COMPONENTS=(farm-services)
        ;;
    shield-elk)
        COMPONENTS=(elk)
        ;;
    *)
        usage
        exit
        ;;
    esac
}

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -n | --namespace)
        shift
        only_namespace "$1"
        ;;
    -k | --keep-namespace)
        ES_DELETE_NAMESPACE=false
        ;;
    -s | --silent)
        ES_CONF=true
        ;;
    #        -h | --help)
    *)
        usage
        exit
        ;;
    esac
    shift
done

if [ "$ES_CONF" = false ]; then
    read -p "Are you sure you want to delete the deployment? " choice
    case "$choice" in
    y | Y | "yes" | "YES" | "Yes")
        echo "yes"
        ES_CONF=true
        ;;
    *)
        echo "no"
        echo "Ok!"
        ;;
    esac
fi

if [ "$ES_CONF" = true ]; then
    echo "***************     Uninstalling $SHIELD"
    for component in "${COMPONENTS[@]}"; do
        helm delete --purge "shield-${component}"
        if [ "$ES_DELETE_NAMESPACE" = true ]; then
            kubectl delete namespace "${component}"
        fi
    done
fi
