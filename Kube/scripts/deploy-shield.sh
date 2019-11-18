#!/bin/bash -e
############################################
#####   Ericom Shield Deploy Shield    #####
#######################################BH###
SHIELD_MNG="yes"
SHIELD_PROXY="yes"
SHIELD_FARM="yes"
SHIELD_ELK="yes"
SET_LABELS="No"
ES_FORCE=false
ES_OVERWRITE=false
NOT_FOUND_STR="404: Not Found"
ES_repo_EULA="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/master/Setup/Ericom-EULA.txt"
EULA_ACCEPTED_FILE=".eula_accepted"
ES_BRANCH_FILE=".esbranch"
BRANCH="Dev"
SHIELD_NS_COUNT=5
SHIELD_REPO="shield-repo"
# For Local Use ..
#SHIELD_REPO=".."
SYSTEMID=$(kubectl get namespace kube-system -o=jsonpath='{.metadata.uid}')
DRY_RUN="" #"--dry-run"

echo $SYSTEMID

# shield-role/management=accept
# shield-role/proxy=accept
# shield-role/elk=accept
# shield-role/farm-services=accept
# shield-role/remote-browsers=accept

LOGFILE=last_deploy.log

function usage() {
    echo " Usage: $0 [-n|--namespace <NAMESPACE>] [-l|--label] [-f|--force] [--help]"
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

function download_and_check(){
     curl -s -S -o "$1" "$2"   
    if [ ! -f "$1" ] || [ $(grep -c "$NOT_FOUND_STR" "$1") -ge 1 ]; then
        echo "Error: cannot download "$1", exiting"
        exit 1
    fi
}

function accept_license() {
    export LESSSECURE=1
    while less -P"%pb\% Press h for help or q to quit" "$1" &&
        read -p "Do you accept the EULA (yes/no/anything else to display it again)? " choice; do
        case "$choice" in
        y | Y | n | N)
            echo 'Please, type "yes" or "no"'
            read -n1 -r -p "Press any key to continue..." key
            ;;
        "yes" | "YES" | "Yes")
            echo "yes"
            return 0
            ;;
        "no" | "NO" | "No")
            echo "no"
            break
            ;;
        *) ;;

        esac
    done

    return -1
}

function accept_eula() {
    download_and_check "Ericom-EULA.txt" "$ES_repo_EULA"
    if [ ! -f "$EULA_ACCEPTED_FILE" ]; then
       echo 'You will now be presented with the End User License Agreement.'
       echo 'Use PgUp/PgDn/Arrow keys for navigation, q to exit.'
       echo 'Please, read the EULA carefully, then accept it to continue the installation process or reject to exit.'
       read -n1 -r -p "Press any key to continue..." key
       echo

       if accept_license "Ericom-EULA.txt"; then
          log_message "EULA has been accepted"
          date -Iminutes >"$EULA_ACCEPTED_FILE"
       else
          log_message "EULA has not been accepted, exiting..."
          exit
       fi
    fi
}

get_timezone() {
    local TZ
    if [ -h /etc/localtime ]; then
        TZ=":$(readlink /etc/localtime | sed 's/\/usr\/share\/zoneinfo\///')"
    elif [ -f /etc/timezone ]; then
        TZ="$(cat /etc/timezone)"
    elif [ -f /etc/localtime ]; then
        TZ=":$(find /usr/share/zoneinfo/ -type f -exec md5sum {} \; | grep "^$(md5sum /etc/localtime | cut -d' ' -f1)" | sed 's/.*\/usr\/share\/zoneinfo\///' | head -n 1)" #"
    else
        TZ="$(date +%Z)"
    fi

    echo $TZ
}

only_namespace(){
   SHIELD_MNG="no"
   SHIELD_PROXY="no"
   SHIELD_FARM="no"
   SHIELD_ELK="no"
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
        shift
        only_namespace "$1"
        ;;
    -l | --label) 
        SET_LABELS="yes"
        ;;
    -o | --overwrite)
        ES_OVERWRITE=true
        ;;
    -f | --force)
        ES_FORCE=true
        ;;
    -approve-eula)
        log_message "EULA has been accepted from Command Line"
        date -Iminutes >"$EULA_ACCEPTED_FILE"
        ;;
    #        -help)
    *)
        usage
        exit
        ;;
    esac
    shift
done


##################      MAIN: EVERYTHING STARTS HERE: ##########################

log_message "***************     Ericom Shield Kube Setup $BRANCH ..."

accept_eula

helm repo update
helm search shield

VERSION_REPO=$(helm search shield | grep shield | awk '{ print $2 }')
log_message "Latest Version on Repo: $VERSION_REPO"

VERSION_DEPLOYED=$(helm list | grep -m 1 shield | awk '{ print $9 }')
if [ ! -z $VERSION_DEPLOYED ] && [ $(helm list | grep -c $VERSION_DEPLOYED) == "$SHIELD_NS_COUNT" ]; then
   VERSION_DEPLOYED=$(helm list | grep -m 1 shield | awk '{ print $9 }')
   log_message "Current Version Deployed: $VERSION_DEPLOYED"
  else
   log_message "Shield is not fully deployed"    
   VERSION_DEPLOYED=""
fi

if [ "shield-$VERSION_REPO" == "$VERSION_DEPLOYED" ]; then
    echo "Your EricomShield System is Up to date ($VERSION_REPO)"
    if [ ! $ES_FORCE = true ]; then
       exit
    fi   
fi

TZ="$(get_timezone)"

UPSTREAM_DNS_SERVERS="$(grep -oP 'nameserver\s+\K.+' /etc/resolv.conf | cut -d, -f2- | paste -sd,)"
if [ "$UPSTREAM_DNS_SERVERS" = "127.0.0.53" ]; then
    UPSTREAM_DNS_SERVERS="$(systemd-resolve --status | grep -oP 'DNS Servers:\s+\K.+' | paste -sd,)"
fi

log_message "***************     Deploying Ericom Shield $VERSION_REPO ..."

if [ -f "$ES_BRANCH_FILE" ]; then
    BRANCH=$(cat "$ES_BRANCH_FILE")
 else
    BRANCH="master"
fi

if [ "$SHIELD_FARM" == "yes" ]; then
    log_message "***************     Deploying Shield Farm Services *******************************"
    if [ "$SET_LABELS" == "yes" ]; then
        kubectl label node --all shield-role/farm-services=accept --overwrite
        kubectl label node --all shield-role/remote-browsers=accept --overwrite
    fi
    if [ $ES_OVERWRITE ] || [ ! -f "custom-farm.yaml" ]; then
        download_and_check custom-farm.yaml https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/custom-farm.yaml
    fi

    helm upgrade --install shield-farm-services $SHIELD_REPO/shield --namespace=farm-services\
                 --set-string "farm-services.TZ=${TZ}" --set-string "farm-services.CLUSTER_SYSTEM_ID=$SYSTEMID"\
                 -f custom-farm.yaml --debug | tee -a "$LOGFILE"
    sleep 30
fi

if [ "$SHIELD_MNG" == "yes" ]; then
    log_message "***************     Deploying Shield Management *******************************"
    if [ "$SET_LABELS" == "yes" ]; then
        kubectl label node --all shield-role/management=accept --overwrite
    fi
    if [ $ES_OVERWRITE ] || [ ! -f "custom-management.yaml" ]; then
        download_and_check custom-management.yaml https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/custom-management.yaml
    fi
    helm upgrade --install shield-management $SHIELD_REPO/shield --namespace=management\
                 --set-string "management.TZ=${TZ}" --set-string "management.CLUSTER_SYSTEM_ID=$SYSTEMID"\
                 -f custom-management.yaml --debug | tee -a "$LOGFILE"

    sleep 30
fi

if [ "$SHIELD_PROXY" == "yes" ]; then
    log_message "***************     Deploying Shield Proxy *******************************"
    if [ "$SET_LABELS" == "yes" ]; then
        kubectl label node --all shield-role/proxy=accept --overwrite
    fi
    if [ ES_OVERWRITE ] || [ ! -f "custom-proxy.yaml" ]; then
        download_and_check custom-proxy.yaml https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/custom-proxy.yaml
    fi
    helm upgrade --install shield-proxy $SHIELD_REPO/shield --namespace=proxy\
                 --set-string "proxy.TZ=${TZ}" --set-string "proxy.CLUSTER_SYSTEM_ID=$SYSTEMID"\
                 -f custom-proxy.yaml --debug | tee -a "$LOGFILE"

    sleep 30
fi

if [ "$SHIELD_ELK" == "yes" ]; then
    log_message "***************     Deploying Shield ELK *******************************"
    if [ "$SET_LABELS" == "yes" ]; then
        kubectl label node --all shield-role/elk=accept --overwrite
    fi
    if [ $ES_OVERWRITE ] || [ ! -f "custom-values-elk" ]; then
        download_and_check custom-values-elk.yaml https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/custom-values-elk.yaml
    fi
    helm upgrade --install shield-elk $SHIELD_REPO/shield --namespace=elk\
                 --set-string "elk.TZ=${TZ}" --set-string "elk.CLUSTER_SYSTEM_ID=$SYSTEMID"\
                 -f custom-values-elk.yaml --debug | tee -a "$LOGFILE"

fi

log_message "***************     Deploying Shield Common *******************************"
if [ $ES_OVERWRITE ] || [ ! -f "custom-common.yaml" ]; then
    download_and_check custom-common.yaml https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/custom-common.yaml
fi
helm upgrade --install shield-common $SHIELD_REPO/shield --namespace=common -f custom-common.yaml --debug | tee -a "$LOGFILE"

log_message "***************     Done!"
