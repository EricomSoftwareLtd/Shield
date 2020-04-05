#!/bin/bash -e
############################################
#####   Ericom Shield Deploy Shield    #####
#######################################BH###

SHIELD_MNG="yes"
SHIELD_PROXY="yes"
SHIELD_FARM="yes"
SHIELD_ELK="yes"
SET_LABELS="No"
ES_FORCE="false"
ES_OVERWRITE="false"
ES_UPDATE="false"
NOT_FOUND_STR="404: Not Found"
ES_PATH="$HOME/ericomshield"
ES_BRANCH_FILE="$ES_PATH/.esbranch"
LOGFILE="$ES_PATH/ericomshield.log"
LAST_DEPLOY_LOGFILE="$ES_PATH/last_deploy.log"
BRANCH="master"
SHIELD_NS_COUNT=5
SHIELD_REPO="shield-repo"
DEBUG="" #"--debug"

# shield-role/management=accept
# shield-role/proxy=accept
# shield-role/elk=accept
# shield-role/farm-services=accept
# shield-role/remote-browsers=accept

function usage() {
    echo " Usage: $0 [-n|--namespace <NAMESPACE> (<NAMESPACE>)] [-l|--label] [-o|--overwrite] [-L|--local] [-f|--force] [-h|--help] [-u|--update]"
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

# Create the Ericom empty dir if necessary
if [ ! -d $ES_PATH ]; then
    mkdir -p $ES_PATH
    chmod 0755 $ES_PATH
fi

function download_and_check() {
    curl -s -S -o "$1" "$2"
    if [ ! -f "$1" ] || [ $(grep -c "$NOT_FOUND_STR" "$1") -ge 1 ]; then
        echo "Error: cannot download "$1", exiting"
        exit 1
    fi
}

get_timezone() {
    local TZ
    if [ -h /etc/localtime ]; then
        TZ=":$(readlink /etc/localtime | sed 's|.*/usr/share/zoneinfo/||')"
    elif [ -f /etc/timezone ]; then
        TZ="$(cat /etc/timezone)"
    elif [ -f /etc/localtime ]; then
        TZ=":$(find /usr/share/zoneinfo/ -type f -exec md5sum {} \; | grep "^$(md5sum /etc/localtime | cut -d' ' -f1)" | sed 's|.*/usr/share/zoneinfo/||' | head -n 1)" #"
    else
        TZ="$(date +%Z)"
    fi

    echo $TZ
}
FIRST_NAMESPACE="true"
only_namespace() {
    if [ $FIRST_NAMESPACE == "true" ]; then
        SHIELD_MNG="no"
        SHIELD_PROXY="no"
        SHIELD_FARM="no"
        SHIELD_ELK="no"
        FIRST_NAMESPACE="false"
    fi
    case "$1" in
    shield-management)
        SHIELD_MNG="yes"
        ;;
    shield-proxy)
        SHIELD_PROXY="yes"
        ;;
    shield-farm)
        SHIELD_FARM="yes"
        ;;
    shield-elk)
        SHIELD_ELK="yes"
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
       if [ -z "$2" ]; then
         echo "missing namespace"
         usage
         exit
        else
         while [ ! -z "$2" ] && [[ "$2" == *"shield-"* ]] ; do
            only_namespace "$2"
            shift
         done
        fi
        ;;
    -l | --label)
        SET_LABELS="yes"
        ;;
    -o | --overwrite)
        ES_OVERWRITE="true"
        ;;
    -L | --local)
        if [ -z "$2" ]; then
          SHIELD_REPO=".."
         else
          SHIELD_REPO="$2"
          shift
        fi
        echo "Local Repo: $SHIELD_REPO"
        ;;
    -f | --force)
        ES_FORCE="true"
        ;;
    -u | --update)
        ES_UPDATE="true"
        ;;
    -h | --help)
#    *)
        usage
        exit
        ;;
    esac
    shift
done

if [ -f "$ES_BRANCH_FILE" ]; then
    BRANCH=$(cat "$ES_BRANCH_FILE")
fi

##################      MAIN: EVERYTHING STARTS HERE: ##########################

log_message "***************     Ericom Shield Kube Setup $BRANCH ..."

SYSTEMID=$(kubectl get namespace kube-system -o=jsonpath='{.metadata.uid}')
echo $SYSTEMID

# If Update need to rename shield folder (on OVA)
if [ "$ES_UPDATE" = "true" ] && [ -d "$ES_PATH/shield-repo" ] ; then
  log_message "Updating Shield (renaming original shield-repo folder) "
  mv "$ES_PATH/shield-repo" "$ES_PATH/shield-repo-org"
fi

# Only when working online (using non-Local-repo)
if [ SHIELD_REPO = "shield-repo" ]; then
    cd "$ES_PATH" || exit 1

    helm repo update
    helm search repo shield
    VERSION_REPO=$(helm search repo shield | grep shield | awk '{ print $2 }')
    log_message "Latest Version on Repo: $VERSION_REPO"
fi

VERSION_DEPLOYED=$(helm ls --all-namespaces| grep -m 1 shield | awk '{ print $9 }')
if [ ! -z "$VERSION_DEPLOYED" ] && [ $(helm ls --all-namespaces | grep -c "$VERSION_DEPLOYED") = "$SHIELD_NS_COUNT" ]; then
    VERSION_DEPLOYED=$(helm ls --all-namespaces | grep -m 1 shield | awk '{ print $9 }')
    log_message "Current Version Deployed: $VERSION_DEPLOYED"
else
    echo "$VERSION_DEPLOYED"
    log_message "Shield is not fully deployed"
    VERSION_DEPLOYED=""
fi

if [ "shield-$VERSION_REPO" = "$VERSION_DEPLOYED" ]; then
    echo "Your EricomShield System is Up to date ($VERSION_REPO)"
    if [ "$ES_FORCE" = "false" ]; then
        exit
    fi
fi

TZ="$(get_timezone)"

UPSTREAM_DNS_SERVERS="$(grep -oP 'nameserver\s+\K.+' /etc/resolv.conf | cut -d, -f2- | paste -sd,)"
if [ "$UPSTREAM_DNS_SERVERS" = "127.0.0.53" ]; then
    UPSTREAM_DNS_SERVERS="$(systemd-resolve --status | grep -oP 'DNS Servers:\s+\K.+' | paste -sd,)"
fi

log_message "***************     Deploying Ericom Shield from Branch:$BRANCH Repo:$VERSION_REPO on System:$SYSTEMID ..."
echo "***************     Deploying Ericom Shield from Branch:$BRANCH Repo:$VERSION_REPO ..." > "$LAST_DEPLOY_LOGFILE"

log_message "***************     Deploying Shield Common *******************************"
if [ "$ES_OVERWRITE" = "true" ] || [ ! -f "custom-common.yaml" ]; then
    download_and_check custom-common.yaml https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/custom-common.yaml
fi
helm upgrade --install shield-common $SHIELD_REPO/shield --namespace=common -f custom-common.yaml $DEBUG | tee -a "$LAST_DEPLOY_LOGFILE"

if [ "$SHIELD_FARM" = "yes" ]; then
    log_message "***************     Deploying Shield Farm Services *******************************"
    if [ "$SET_LABELS" = "yes" ]; then
        log_message "Setting Labels: farm-services, remote-browsers"
        kubectl label node --all shield-role/farm-services=accept --overwrite
        kubectl label node --all shield-role/remote-browsers=accept --overwrite
    fi
    if [ "$ES_OVERWRITE" = "true" ] || [ ! -f "custom-farm.yaml" ]; then
        download_and_check custom-farm.yaml https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/custom-farm.yaml
    fi

    helm upgrade --install shield-farm-services $SHIELD_REPO/shield --namespace=farm-services \
        --set-string "farm-services.TZ=${TZ}" --set-string "farm-services.CLUSTER_SYSTEM_ID=$SYSTEMID" \
        -f custom-farm.yaml $DEBUG | tee -a "$LAST_DEPLOY_LOGFILE"
    sleep 30
fi

if [ "$SHIELD_MNG" = "yes" ]; then
    log_message "***************     Deploying Shield Management *******************************"
    if [ "$SET_LABELS" = "yes" ]; then
        log_message "Setting Labels: management"
        kubectl label node --all shield-role/management=accept --overwrite
    fi
    if [ "$ES_OVERWRITE" = "true" ] || [ ! -f "custom-management.yaml" ]; then
        download_and_check custom-management.yaml https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/custom-management.yaml
    fi
    helm upgrade --install shield-management $SHIELD_REPO/shield --namespace=management \
        --set-string "shield-mng.TZ=${TZ}" --set-string "shield-mng.CLUSTER_SYSTEM_ID=$SYSTEMID" \
        -f custom-management.yaml $DEBUG | tee -a "$LAST_DEPLOY_LOGFILE"

    sleep 30
fi

if [ "$SHIELD_PROXY" = "yes" ]; then
    log_message "***************     Deploying Shield Proxy *******************************"
    if [ "$SET_LABELS" = "yes" ]; then
        log_message "Setting Labels: proxy"
        kubectl label node --all shield-role/proxy=accept --overwrite
    fi
    if [ "$ES_OVERWRITE" = "true" ] || [ ! -f "custom-proxy.yaml" ]; then
        download_and_check custom-proxy.yaml https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/custom-proxy.yaml
    fi
    helm upgrade --install shield-proxy $SHIELD_REPO/shield --namespace=proxy \
        --set-string "shield-proxy.TZ=${TZ}" --set-string "shield-proxy.CLUSTER_SYSTEM_ID=$SYSTEMID" \
        --set-string "shield-proxy.UPSTREAM_DNS_SERVERS=$(echo ${UPSTREAM_DNS_SERVERS} | sed 's#,#\\,#g')" \
        -f custom-proxy.yaml $DEBUG | tee -a "$LAST_DEPLOY_LOGFILE"

    sleep 30
fi

if [ "$SHIELD_ELK" = "yes" ]; then
    log_message "***************     Deploying Shield ELK *******************************"
    if [ "$SET_LABELS" = "yes" ]; then
        log_message "Setting Labels: elk"
        kubectl label node --all shield-role/elk=accept --overwrite
    fi
    if [ "$ES_OVERWRITE" = "true" ] || [ ! -f "custom-values-elk.yaml" ]; then
        download_and_check custom-values-elk.yaml https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/custom-values-elk.yaml
    fi
    helm upgrade --install shield-elk $SHIELD_REPO/shield --namespace=elk \
        --set-string "elk.TZ=${TZ}" --set-string "elk.CLUSTER_SYSTEM_ID=$SYSTEMID" \
        -f custom-values-elk.yaml $DEBUG | tee -a "$LAST_DEPLOY_LOGFILE"

fi

log_message "***************     Done!"

helm list

exit 0
