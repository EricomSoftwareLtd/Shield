#!/bin/bash
############################################
#####   Ericom Shield: Install Shield  #####
#######################################BH###

NOT_FOUND_STR="404: Not Found"
ES_PATH="$HOME/ericomshield"
ES_BRANCH_FILE="$ES_PATH/.esbranch"
BRANCH="master"
LOGFILE="$ES_PATH/last_deploy.log"
CLUSTER_NAME="shield-cluster"
CLUSTER_CREATED="false"
RANCHER_CLI="true"

function usage() {
    echo " Usage: $0 -p <PASSWORD> [-d|--dev] [-s|--staging] [-f|--force] [-h|--help]"
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
ES_repo_prepare_servers= "https://github.com/EricomSoftwareLtd/Shield/releases/download/shield-prepare-servers-$BRANCH/shield-prepare-servers"
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

CLUSTER_NAME="shield-cluster"
ES_repo_rancher_cli="https://github.com/rancher/cli/releases/download/v2.3.2/rancher-linux-amd64-v2.3.2.tar.xz"
ES_file_rancher_cli="rancher-linux-amd64-v2.3.2.tar.xz"
RANCHER_API_KEY="NDY"
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
    # Create API key good forever
    RANCHER_API_KEY=`curl -k -s 'https://127.0.0.1:8443/v3/token' -H 'Content-Type: application/json' -H "Authorization: Bearer $LOGINTOKEN" --data-binary '{"type":"token","description":"for shield installations"}' | jq -r .token`
    echo "API Key: ${RANCHER_API_KEY}"
    # Set server-url
    MY_IP="$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')"
    RANCHER_SERVER_URL="https://$MY_IP:8443"
    echo "SERVER_URL=$RANCHER_SERVER_URL"
    SERVER_URL_JSN="{\"name\":\"server-url\",\"value\":\"${RANCHER_SERVER_URL}\"}"
    echo $SERVER_URL_JSN
    curl -k 'https://127.0.0.1:8443/v3/settings/server-url' -H 'Content-Type: application/json' -H "Authorization: Bearer $RANCHER_API_KEY" -X PUT --data-binary "$SERVER_URL_JSN"
    return 0
}

# Create Cluster (Thx to Andrei)
function create_cluster(){

   if [ -z $RANCHER_API_KEY ]; then
      # Read the API details
      echo "It didnt work, please Create Rancher Token from UI"
      read -p 'Enter server URL https://<SERVER_URL>: ' LOCAL_RANCHER_SERVER_URL
      read -p 'Enter server BEARER TOKEN: ' RANCHER_API_KEY
   fi

   echo "Rancher login:"
   sudo rancher login --token $RANCHER_API_KEY --skip-verify $LOCAL_RANCHER_SERVER_URL
   sleep 5
   echo "Creating the Cluster:"
   rancher cluster create --network-provider flannel $CLUSTER_NAME
   rancher context switch
   CLUSTER_CREATED="true"
   sleep 5
   echo "Registering node:"
   ADD_NODE_CMD=$(rancher cluster add-node $CLUSTER_NAME | grep docker)
   ROLES_CMD=" --etcd --controlplane --worker"

   if [ ! -z ${ADD_NODE_CMD} ]; then
      return 1
    else
      eval $ADD_NODE_CMD$ROLES_CMD
      sleep 5
      rancher cluster kf $CLUSTER_NAME > ~/.kube/config
      sleep 180
   fi
   return 0
}

function move_namespaces
{   
   # Create (if not exist) and moving Namespaces
   if [ $(kubectl get namespace elk | grep -c active) -ge 1 ]; then
      kubectl create namespace elk
   fi
   rancher namespaces move elk Default
   if [ $(kubectl get namespace farm-services  | grep -c active) -ge 1 ]; then
      kubectl create namespace farm-services
   fi   
   rancher namespaces move farm-services Default
   if [ $(kubectl get namespace management | grep -c active) -ge 1 ]; then
      kubectl create namespace management
   fi   
   rancher namespaces move management Default
   if [ $(kubectl get namespace proxy | grep -c active) -ge 1 ]; then
      kubectl create namespace proxy
   fi   
   rancher namespaces move management Default
   if [ $(kubectl get namespace common | grep -c active) -ge 1 ]; then
      kubectl create namespace common
   fi   
   rancher namespaces move common Default
   sleep 5
}

##################      MAIN: EVERYTHING STARTS HERE: ##########################
log_message "***************     Ericom Shield Installer $BRANCH ..."

if [ ! -f ~/.kube/config ] || [ $(cat ~/.kube/config | wc -l) -le 1 ]; then

   #0.1.  Downloading Files
   download_files
   
   #1.  Run configure-sysctl-values.sh
   echo
   log_message "***************     Configure sysctl values"
   source "./$ES_file_sysctl"
   if [ $? != 0 ]; then
      log_message "*************** $ES_file_sysctl Failed, Exiting!"
      exit 1
   fi

   #2.  install-docker.sh
   echo
   log_message "***************     Installing Docker"
   source "./$ES_file_docker"
   if [ $? != 0 ]; then
      log_message "*************** $ES_file_docker Failed, Exiting!"
      exit 1
   fi

   #3.  install-kubectl.sh
   echo
   log_message "***************     Installing Kubectl"
   source "./$ES_file_kubectl"
   if [ $? != 0 ]; then
      log_message "*************** $ES_file_kubectl Failed, Exiting!"
      exit 1
   fi

   #4.  run-rancher.sh
   echo
   log_message "***************     Running Rancher Server"
   source "./$ES_file_rancher"
   if [ $? != 0 ]; then
      log_message "*************** $ES_file_run_rancher Failed, Exiting!"
      exit 1
   fi

   if [ $RANCHER_CLI="true" ]; then
      install_if_not_installed jq
      sleep 5
      install_rancher_cli
      sleep 5
      # wait launched rancher
      log_message "Waiting for Rancher"
      while ! curl -s -k "${RANCHER_SERVER_URL}/ping"; 
      do 
        sleep 3; 
      done

      generate_rancher_token
      sleep 5
      create_cluster
      sleep 5
      move_namespaces
   fi
   if [ $CLUSTER_CREATED="false" ]; then
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

#while :
#    do
#       TILLERSTATE=$(kubectl get deployment.apps/tiller-deploy -n kube-system | grep 1/1 )
#       echo "Waiting for state to become available.: $TILLERSTATE" | tee -a $LOGFILE
#       if [[ $TILLERSTATE -ge 1 ]] ;then
#           break
#       fi
#       sleep 10
#done

#5. Adding Shield Repo
echo
log_message "***************     Adding Shield Repo"
source "./$ES_file_addrepo" $@
if [ $? != 0 ]; then
   log_message "*************** $ES_file_repo Failed, Exiting!"
   exit 1
fi

#6. Deploy Shield
log_message "***************     Deploy Shield"
bash "./$ES_file_deploy_shield"
if [ $? != 0 ]; then
   log_message "*************** $ES_file_deploy_shield Failed, Exiting!"
   exit 1
fi
log_message "***************     Done !!!"   
