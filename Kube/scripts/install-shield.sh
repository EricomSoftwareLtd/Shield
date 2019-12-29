#!/bin/bash
############################################
#####   Ericom Shield: Install Shield  #####
#######################################BH###

NOT_FOUND_STR="404: Not Found"
STEP_BY_STEP="false"
ES_PATH="$HOME/ericomshield"
ES_BRANCH_FILE="$ES_PATH/.esbranch"
BRANCH="master"
LOGFILE="$ES_PATH/last_deploy.log"
RANCHER_CLI="false"
RANCHER_URL_FILE="$ES_PATH/.esrancherurl"
RANCHER_TOKEN_FILE="$ES_PATH/.esranchertoken"
CLUSTER_NAME="shield-cluster"
CLUSTER_CREATED="false"

function usage() {
    echo " Usage: $0 -p <PASSWORD> [-d|--dev] [-s|--staging] [-R|--ranchercli] [-f|--force] [-h|--help]"
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
    -d | --dev) # Dev Channel (dev branch)
        echo -n "Dev" >"$ES_BRANCH_FILE"
        ;;
    -s | --staging) # Staging Channel (staging Branch)
        echo -n "Staging" >"$ES_BRANCH_FILE"
        ;;
    -v | --version)
        shift
        echo -n "$1" >"$ES_BRANCH_FILE"
        ;;        
    -R | --ranchercli)
        RANCHER_CLI="true"
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

ES_repo_sysctl="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/configure-sysctl-values.sh"
ES_repo_docker="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/install-docker.sh"
ES_repo_kubectl="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/install-kubectl.sh"
ES_repo_rancher="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/run-rancher.sh"
ES_repo_helm="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/install-helm.sh"
ES_repo_addrepo="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/add-shield-repo.sh"
ES_repo_deploy_shield="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/deploy-shield.sh"
ES_repo_delete_shield="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Kube/scripts/delete-shield.sh"
ES_repo_prepare_servers="https://github.com/EricomSoftwareLtd/Shield/releases/download/$BRANCH/shield-prepare-servers"
ES_repo_rancher_cli="https://github.com/rancher/cli/releases/download/v2.3.2/rancher-linux-amd64-v2.3.2.tar.xz"

ES_file_sysctl="configure-sysctl-values.sh"
ES_file_rancher="run-rancher.sh"
ES_file_docker="install-docker.sh"
ES_file_kubectl="install-kubectl.sh"
ES_file_helm="install-helm.sh"
ES_file_addrepo="add-shield-repo.sh"
ES_file_deploy_shield="deploy-shield.sh"
ES_file_delete_shield="delete-shield.sh"
ES_file_prepare_servers="shield-prepare-servers"
ES_file_rancher_cli="rancher-linux-amd64-v2.3.2.tar.xz"

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
    if [ $STEP_BY_STEP = "true" ];then
       read -p 'Press Enter to continue...' ENTER
    fi
}

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

function download_files() {
    download_and_check "$ES_file_sysctl" "$ES_repo_sysctl" "+x"
    download_and_check "$ES_file_docker" "$ES_repo_docker" "+x"
    download_and_check "$ES_file_kubectl" "$ES_repo_kubectl" "+x"
    download_and_check "$ES_file_rancher" "$ES_repo_rancher" "+x"
    download_and_check "$ES_file_helm" "$ES_repo_helm" "+x"
    download_and_check "$ES_file_addrepo" "$ES_repo_addrepo" "+x"
    download_and_check "$ES_file_deploy_shield" "$ES_repo_deploy_shield" "+x"
    download_and_check "$ES_file_delete_shield" "$ES_repo_delete_shield" "+x"
    curl -sL -S -o "$ES_file_prepare_servers" "$ES_repo_prepare_servers"
}

#########################################################################################################################

RANCHER_API_TOKEN="NDY"
RANCHER_SERVER_URL="NDY"
LOCAL_RANCHER_SERVER_URL="https://127.0.0.1:8443"

function install_if_not_installed() {
    if ! dpkg -s "$1" >/dev/null 2>&1; then
        echo "***************     Installing $1"
        apt-get --assume-yes -y install "$1"
    fi
}

function install_rancher_cli() {
    if ! which rancher >/dev/null ; then
       wget "$ES_repo_rancher_cli"
       tar xf "$ES_file_rancher_cli"
       mv rancher-*/rancher /usr/bin/
       rm -rf rancher-*
    fi
}

# Generate Rancher Token (Thx to Erez)
function generate_rancher_token() {
    #read es_rancher files

    if [ -f $RANCHER_URL_FILE ];then
       RANCHER_SERVER_URL=$(cat $RANCHER_URL_FILE)
    fi

    if [ -f $RANCHER_TOKEN_FILE ];then
       RANCHER_API_TOKEN=$(cat $RANCHER_TOKEN_FILE)
    fi

    # Login token good for 1 minute
    LOGINTOKEN=`curl -k -s 'https://127.0.0.1:8443/v3-public/localProviders/local?action=login' -H 'content-type: application/json' --data-binary '{"username":"admin","password":"admin","ttl":60000}' | jq -r .token`
    if [ "$LOGINTOKEN" = null ]; then
        LOGINTOKEN=`curl -k -s 'https://127.0.0.1:8443/v3-public/localProviders/local?action=login' -H 'content-type: application/json' --data-binary '{"username":"admin","password":"ericomshield","ttl":60000}' | jq -r .token`
        else
        # Change password
        curl -k -s 'https://127.0.0.1:8443/v3/users?action=changepassword' -H 'Content-Type: application/json' -H "Authorization: Bearer $LOGINTOKEN" --data-binary '{"currentPassword":"admin","newPassword":"ericomshield"}'
    fi
    echo "LOGINTOKEN=$LOGINTOKEN"
    if [ "$LOGINTOKEN" = null ]; then
       return 1
    fi
    # Create API Token good forever
    RANCHER_API_TOKEN=`curl -k -s 'https://127.0.0.1:8443/v3/token' -H 'Content-Type: application/json' -H "Authorization: Bearer $LOGINTOKEN" --data-binary '{"type":"token","description":"for shield installations"}' | jq -r .token`
    echo "API Token: ${RANCHER_API_TOKEN}"
    echo $RANCHER_API_TOKEN > $RANCHER_TOKEN_FILE    
    # Set server-url
    echo "SERVER_URL=$RANCHER_SERVER_URL"
    SERVER_URL_JSN="{\"name\":\"server-url\",\"value\":\"${RANCHER_SERVER_URL}\"}"
    echo $SERVER_URL_JSN
    curl -k 'https://127.0.0.1:8443/v3/settings/server-url' -H 'Content-Type: application/json' -H "Authorization: Bearer $RANCHER_API_TOKEN" -X PUT --data-binary "$SERVER_URL_JSN"
    return 0
}

# Wait until Rancher is launched
function wait_for_rancher(){
    #read es_rancher files
    #read es_rancher files
    if [ -f $RANCHER_URL_FILE ];then
       RANCHER_SERVER_URL=$(cat $RANCHER_URL_FILE)
     else
       MY_IP="$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')"
       RANCHER_SERVER_URL="https://$MY_IP:8443"
       echo $RANCHER_SERVER_URL > $RANCHER_URL_FILE
    fi   
    log_message "Waiting for Rancher: ${RANCHER_SERVER_URL}"
    RANCHER_PONG="NDY"
    wait_count=0
    while [ ! "$RANCHER_PONG" = "pong" ] && ((wait_count < 10)); do
      echo -n .
      sleep 3
      wait_count=$((wait_count + 1))
      RANCHER_PONG=$(curl -s -k "${RANCHER_SERVER_URL}/ping")
      echo "$RANCHER_PONG"
    done
    if [ ! "$RANCHER_PONG" = "pong" ]; then
      echo
      log_message "Error: Cannot Connect to Rancher on: ${RANCHER_SERVER_URL}"
      exit 1
     else
      echo "ok!"
      return 0
    fi
}

function wait_for_rancher_cluster(){
    # Wait until Cluster is active
    log_message "Waiting for Shield Cluster state to become active ."
    CLUSTER_STATE=0
    wait_count=0
    while [ "$CLUSTER_STATE" -lt 1 ] && ((wait_count < 30)); do
      echo -n .
      sleep 10
      wait_count=$((wait_count + 1))
      CLUSTER_STATE=$(rancher cluster shield-cluster | grep -c -w active)
    done
    if [ "$CLUSTER_STATE" -lt 1 ]; then
      echo
      log_message "Error: Shield Cluster is not active, please check on Rancher UI."
      exit 1
    fi
    echo "ok!"
    return 0
}

# Create Cluster (Thx to Andrei)
function create_rancher_cluster(){

   if [ -z $RANCHER_API_TOKEN ]; then
      # Read the API details
      echo "It didnt work, please Create Rancher Token from UI"
      read -p 'Enter server URL https://<SERVER_URL>: ' LOCAL_RANCHER_SERVER_URL
      read -p 'Enter server BEARER TOKEN: ' RANCHER_API_TOKEN
   fi

   echo "Rancher login:"
   rancher login --token $RANCHER_API_TOKEN --skip-verify $LOCAL_RANCHER_SERVER_URL
   sleep 5
   echo "Creating the Cluster:"
   rancher cluster create --network-provider flannel $CLUSTER_NAME
   rancher context switch
   echo "Rancher login (again):"
   rancher login --token $RANCHER_API_TOKEN --skip-verify $LOCAL_RANCHER_SERVER_URL
   CLUSTER_CREATED="true"
   sleep 5
   echo "Registering node:"
   ADD_NODE_CMD=$(rancher cluster add-node $CLUSTER_NAME | grep docker)
   ROLES_CMD=" --etcd --controlplane --worker"

   if [ -z "${ADD_NODE_CMD}" ]; then
      return 1
    else
      eval $ADD_NODE_CMD$ROLES_CMD
   fi
   
   wait_for_rancher_cluster
   
   rancher cluster kf $CLUSTER_NAME > ~/.kube/config
   
   return 0
}

function move_namespaces
{   
   # Create (if not exist) and moving Namespaces
   if [ $(kubectl get namespace | grep elk | grep -c Active) -le 0 ]; then
      kubectl create namespace elk
   fi
   rancher namespaces move elk Default
   if [ $(kubectl get namespace | grep farm-services  | grep -c Active) -le 0 ]; then
      kubectl create namespace farm-services
   fi   
   rancher namespaces move farm-services Default
   if [ $(kubectl get namespace | grep management | grep -c Active) -le 0 ]; then
      kubectl create namespace management
   fi   
   rancher namespaces move management Default
   if [ $(kubectl get namespace | grep proxy | grep -c Active) -le 0 ]; then
      kubectl create namespace proxy
   fi   
   rancher namespaces move management Default
   if [ $(kubectl get namespace | grep common | grep -c Active) -le 0 ]; then
      kubectl create namespace common
   fi   
   rancher namespaces move common Default
}

function wait_for_tiller(){
    # Wait until Tiller is available
    log_message "Waiting for Tiller state to become available.: $TILLERSTATE"
    TILLERSTATE=0
    wait_count=0
    while [ "$TILLERSTATE" -lt 1 ] && ((wait_count < 10)); do
      echo -n .
      sleep 3
      wait_count=$((wait_count + 1))
      TILLERSTATE=$(kubectl -n kube-system get deployments | grep tiller-deploy | grep -c 1/1 )
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
log_message "***************     Ericom Shield Installer $BRANCH ..."

if [ ! -f ~/.kube/config ] || [ $(cat ~/.kube/config | wc -l) -le 1 ]; then

   #0.  Downloading Files
   download_files
   
   #1.  Run configure-sysctl-values.sh
   echo
   log_message "***************     Configure sysctl values"
   source "./$ES_file_sysctl"
   if [ $? != 0 ]; then
      log_message "*************** $ES_file_sysctl Failed, Exiting!"
      exit 1
   fi

   step

   #2.  install-docker.sh
   echo
   log_message "***************     Installing Docker"
   source "./$ES_file_docker"
   if [ $? != 0 ]; then
      log_message "*************** $ES_file_docker Failed, Exiting!"
      exit 1
   fi

   step

   #3.  install-kubectl.sh
   echo
   log_message "***************     Installing Kubectl"
   source "./$ES_file_kubectl"
   if [ $? != 0 ]; then
      log_message "*************** $ES_file_kubectl Failed, Exiting!"
      exit 1
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

   if [ $RANCHER_CLI = "true" ]; then

      install_if_not_installed jq

      install_rancher_cli

      step

      wait_for_rancher

      step

      generate_rancher_token

      step

      create_rancher_cluster

      step

      move_namespaces

      step
   fi

   if [ $CLUSTER_CREATED = "false" ]; then
     echo
     echo "Please Create your cluster, Set Labels, Set ~/.kube/config and come back...."
     exit 0
   fi
fi

#4. install-helm.sh
echo
log_message "***************     Installing Helm"
bash "./$ES_file_helm"
if [ $? != 0 ]; then
   log_message "*************** $ES_file_helm Failed, Exiting!"
   exit 1
fi

step

wait_for_tiller

step

#5. Adding Shield Repo
echo
log_message "***************     Adding Shield Repo"
"./$ES_file_addrepo" $args
if [ $? != 0 ]; then
   log_message "*************** $ES_file_repo Failed, Exiting!"
   exit 1
fi

step

#6. Deploy Shield
log_message "***************     Deploy Shield"
"./$ES_file_deploy_shield" $args
if [ $? != 0 ]; then
   log_message "*************** $ES_file_deploy_shield Failed, Exiting!"
   exit 1
fi
log_message "***************     Done !!!"   
