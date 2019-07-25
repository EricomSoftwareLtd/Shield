#!/bin/bash -e
############################################
#####   Ericom Shield Deploy Shield    #####
#######################################BH###
SHIELD_MNG="yes"
SHIELD_PROXY="yes"
SHIELD_FARM="yes"
SHIELD_ELK="yes"
SET_LABELS="No"
BRANCH="Staging"

# shield-role/management=accept
# shield-role/proxy=accept
# shield-role/elk=accept
# shield-role/farm-services=accept
# shield-role/remote-browsers=accept

LOGFILE=last_deploy.log

function log_message() {
    local PREV_RET_CODE=$?
    echo "$@"
    echo "$(LC_ALL=C date): $@" >>"$LOGFILE"
    if ((PREV_RET_CODE != 0)); then
        return 1
    fi
    return 0
}

helm repo update
helm search shield
VERSION_REPO=$(helm search shield | grep shield | awk '{ print $2 }')
echo "Latest Version : $VERSION_REPO"
VERSION_DEPLOYED=$(helm list shield | grep shield | awk '{ print $9 }')
echo "Current Version: $VERSION_DEPLOYED"

if [ "$VERSION_REPO" == "$VERSION_DEPLOYED" ]; then
    echo "Same Versions, nothing to do"
    exit
fi

CUSTOM_VALUES_FILE="custom-values.yaml"

if [ -n "$1" ]; then
    CUSTOM_VALUES_FILE="$1"

    if [ ! -f "$CUSTOM_VALUES_FILE" ]; then
        echo "File $CUSTOM_VALUES_FILE not found"
        exit 1
    fi
fi

TZ="$(date +%Z)"

UPSTREAM_DNS_SERVERS="$(grep -oP 'nameserver\s+\K.+' /etc/resolv.conf | cut -d, -f2- | paste -sd,)"
if [ "$UPSTREAM_DNS_SERVERS" = "127.0.0.53" ]; then
    UPSTREAM_DNS_SERVERS="$(systemd-resolve --status | grep -oP 'DNS Servers:\s+\K.+' | paste -sd,)"
fi

log_message "***************     Deploying Ericom Shield $VERSION_REPO ..."

if [ "$SHIELD_FARM" == "yes" ]; then
    log_message "***************     Deploying Shield Farm Services *******************************"
    if [ "$SET_LABELS" == "yes" ]; then
        kubectl label node --all shield-role/farm-services=accept --overwrite
        kubectl label node --all shield-role/remote-browsers=accept --overwrite
    fi
    if [ ! -f "custom-farm.yaml" ]; then
       curl -s -o custom-farm.yaml https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/custom-farm.yaml
    fi

    helm upgrade --install shield-farm-services shield-repo/shield --namespace=farm-services --set-string "farm-services.TZ=${TZ}" -f custom-farm.yaml --debug | tee -a "$LOGFILE"
    sleep 30
fi

if [ "$SHIELD_MNG" == "yes" ]; then
    log_message "***************     Deploying Shield Management *******************************"
    if [ "$SET_LABELS" == "yes" ]; then
        kubectl label node --all shield-role/management=accept --overwrite
    fi
    if [ ! -f "custom-management.yaml" ]; then
       curl -s -o custom-management.yaml https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/custom-management.yaml
    fi
    helm upgrade --install shield-management shield-repo/shield --namespace=management --set-string "shield-mng.TZ=${TZ}" -f custom-management.yaml --debug | tee -a "$LOGFILE"
    sleep 30
fi

if [ "$SHIELD_PROXY" == "yes" ]; then
    log_message "***************     Deploying Shield Proxy *******************************"
    if [ "$SET_LABELS" == "yes" ]; then
        kubectl label node --all shield-role/proxy=accept --overwrite
    fi
    if [ ! -f "custom-proxy.yaml" ]; then
        curl -s -o custom-proxy.yaml https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/custom-proxy.yaml
    fi
    helm upgrade --install shield-proxy shield-repo/shield --namespace=proxy --set-string "shield-proxy.TZ=${TZ}" --set-string "shield-proxy.UPSTREAM_DNS_SERVERS=${UPSTREAM_DNS_SERVERS}" -f custom-proxy.yaml --debug | tee -a "$LOGFILE"
    sleep 30
fi

if [ "$SHIELD_ELK" == "yes" ]; then
    log_message "***************     Deploying Shield ELK *******************************"
    if [ "$SET_LABELS" == "yes" ]; then
        kubectl label node --all shield-role/elk=accept --overwrite
    fi
    if [ ! -f "custom-values-elk" ]; then
       curl -s -o custom-values-elk.yaml https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/custom-values-elk.yaml
    fi
    helm upgrade --install shield-elk shield-repo/shield --namespace=elk -f custom-values-elk.yaml --debug | tee -a "$LOGFILE"
fi

log_message "***************     Done!"
 