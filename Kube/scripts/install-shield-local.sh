#!/bin/bash
############################################
#####   Ericom Shield: Install Shield  #####
#######################################BH###

NOT_FOUND_STR="404: Not Found"
STEP_BY_STEP="false"
ES_PATH="$HOME/ericomshield"
ES_BRANCH_FILE="$ES_PATH/.esbranch"
BRANCH="master"
LOGFILE="$ES_PATH/ericomshield.log"
ES_OFFLINE="false"

function usage() {
    echo " Usage: $0 [-l|--label] [-R|--ranchercli] [-f|--force] [-h|--help]"
}

#Check if we are root
if ((EUID != 0)); then
    # sudo su
    usage
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

# Create the Ericom empty dir if necessary
if [ ! -d $ES_PATH ]; then
    mkdir -p $ES_PATH
    chmod 0755 $ES_PATH
fi

cd "$ES_PATH" || exit 1

args="$@"

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -O | --offline)
        ES_OFFLINE="true"
        ;;
    -m | --min-cluster)
        ES_CLUSTER_MIN="true"
        ;;
    -h | --help)
        #    *)
        usage
        exit
        ;;
    esac
    shift
done

ES_file_sysctl="configure-sysctl-values.sh"
ES_file_rancher="run-rancher.sh"
ES_file_rancher_cli="rancher-cli.sh"
ES_file_kubectl="install-kubectl.sh"
ES_file_helm="install-helm.sh"
ES_file_deploy_shield="deploy-shield.sh"
ES_file_prepare_servers="shield-prepare-servers"

function log_message() {
    local PREV_RET_CODE=$?
    echo "$@"
    echo "$(LC_ALL=C date): $@" >>"$LOGFILE"
    if ((PREV_RET_CODE != 0)); then
        return 1
    fi
    return 0
}

function step() {
    if [ $STEP_BY_STEP = "true" ]; then
        read -p 'Press Enter to continue...' ENTER
    fi
}

# download TO (local-file) FROM (remote-url)
# [+x] chmod executable
function download_and_check() {
    curl -sL -S -o "$1" "$2"
    if [ ! -f "$1" ] || [ $(grep -c -x "$NOT_FOUND_STR" "$1") -ge 1 ]; then
        log_message "Error: cannot download "$2", exiting"
        exit 1
    fi
    if [ "$3a" = "+xa" ]; then
        chmod +x "$1"
    fi
}

function wait_for_tiller() {
    # Wait until Tiller is available
    log_message "Waiting for Tiller state to become available.: $TILLERSTATE"
    TILLERSTATE=0
    wait_count=0
    while [ "$TILLERSTATE" -lt 1 ] && ((wait_count < 60)); do
        echo -n .
        sleep 3
        wait_count=$((wait_count + 1))
        TILLERSTATE=$(kubectl -n kube-system get deployments | grep tiller-deploy | grep -c 1/1)
        # if after 90 sec still not available, try to re-install
        if [ wait_count = 30 ]; then
            bash "./$ES_file_helm" -c
            if [ $? != 0 ]; then
                log_message "*************** $ES_file_helm Failed, Exiting!"
                exit 1
            fi
        fi
    done
    if [ "$TILLERSTATE" -lt 1 ]; then
        echo
        log_message "Error: Tiller Deployment is not available "
        exit 1
    else
        echo "ok!"
        return 0
    fi
}

##################      MAIN: EVERYTHING STARTS HERE: ##########################
log_message "***************     Ericom Shield Installer LOCAL ..."

docker version
if [ $? != 0 ]; then
   log_message "FATAL: Docker is not installed exiting..."
   exit 1
fi

if [ ! -f ~/.kube/config ] || [ $(cat ~/.kube/config | wc -l) -le 1 ]; then
    
    #1.  Run configure-sysctl-values.sh
    echo
    log_message "***************     Configure sysctl values"
    source "./$ES_file_sysctl"
    if [ $? != 0 ]; then
        log_message "*************** $ES_file_sysctl Failed, Exiting!"
        exit 1
    fi

    step
    #2.  install-kubectl.sh
    #TODO map kubectl bin from shield-cli to host
    if [ $ES_OFFLINE = "false" ]; then
        echo
        log_message "***************     Installing Kubectl"
        source "./$ES_file_kubectl"
        if [ $? != 0 ]; then
            log_message "*************** $ES_file_kubectl Failed, Exiting!"
            exit 1
        fi
    else
        kubectl version --client
        if [ $? != 0 ]; then
            echo "offline mode: kubectl is not installed..."
            exit 1
        fi
    fi
    step

    #4.  run-rancher.sh
    echo
    log_message "***************     Running Rancher Server"
    source "./$ES_file_rancher"
    if [ $? != 0 ]; then
        log_message "*************** $ES_file_run_rancher Failed, Exiting!"
        exit 1
    fi

    source "./$ES_file_rancher_cli"
    if [ $? != 0 ]; then
       log_message "*************** $ES_file_run_rancher Failed, Exiting!"
       exit 1
    fi
fi

if [ ! -f ~/.kube/config ] || [ $(cat ~/.kube/config | wc -l) -le 1 ]; then
    echo
    echo "Please Create your cluster, Set Labels, Set ~/.kube/config and come back...."
    exit 0
fi

#4. install-helm.sh
echo 
#TODO map helm bin from shield-cli to host
log_message "***************     Installing Helm"
bash "./$ES_file_helm" -i
if [ $? != 0 ]; then
    log_message "*************** $ES_file_helm Failed, Exiting!"
    exit 1
fi

step

wait_for_tiller

step

#6. Deploy Shield
log_message "***************     Deploy Shield"
"./$ES_file_deploy_shield" -L .
if [ $? != 0 ]; then
    log_message "*************** $ES_file_deploy_shield Failed, Exiting!"
    exit 1
fi
log_message "***************     Done !!!"