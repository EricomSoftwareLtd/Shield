#!/bin/bash
############################################
#####   Ericom Shield: Install Shield  #####
#######################################BH###

NOT_FOUND_STR="404: Not Found"
ES_PATH="$HOME/ericomshield"
ES_BRANCH_FILE="$ES_PATH/.esbranch"
BRANCH="master"
LOGFILE="last_deploy.log"

function usage() {
    echo " Usage: $0 -p <PASSWORD> [-d|--dev] [-s|--staging] [-f|--force] [-h|--help]"
}

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
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
ES_repo_prepare_servers="https://github.com/EricomSoftwareLtd/Shield/raw/$BRANCH/Kube/PrepareNode/shield-prepare-servers"

ES_file_sysctl="configure-sysctl-values.sh"
ES_file_rancher="run-rancher.sh"
ES_file_docker="install-docker.sh"
ES_file_kubectl="install-kubectl.sh"
ES_file_helm="install-helm.sh"
ES_file_addrepo="add-shield-repo.sh"
ES_file_deploy_shield="deploy-shield.sh"
ES_file_delete_shield="delete-shield.sh"
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

function download_and_check() {
    curl -s -S -o "$1" "$2"
    if [ ! -f "$1" ] || [ $(grep -c -x "$NOT_FOUND_STR" "$1") -ge 1 ]; then
        log_message "Error: cannot download "$2", exiting"
        exit 1
    fi
    if [ "$3a" = "+xa" ]; then
       chmod +x "$1"
    fi
}

download_and_check "$ES_file_sysctl" "$ES_repo_sysctl" "+x"
download_and_check "$ES_file_docker" "$ES_repo_docker" "+x"
download_and_check "$ES_file_kubectl" "$ES_repo_kubectl" "+x"
download_and_check "$ES_file_rancher" "$ES_repo_rancher" "+x"
download_and_check "$ES_file_helm" "$ES_repo_helm" "+x"
download_and_check "$ES_file_addrepo" "$ES_repo_addrepo" "+x"
download_and_check "$ES_file_deploy_shield" "$ES_repo_deploy_shield" "+x"
download_and_check "$ES_file_delete_shield" "$ES_repo_delete_shield" "+x"
download_and_check "$ES_file_prepare_servers" "$ES_repo_prepare_servers" "+x"

##################      MAIN: EVERYTHING STARTS HERE: ##########################

log_message "***************     Ericom Shield Installer $BRANCH ..."

if [ ! -f ~/.kube/config ] || [ $(cat ~/.kube/config | wc -l) -le 1 ]; then
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

   echo
   echo "Please Create your cluster, Set Labels, Set ~/.kube/config and come back...."
   exit 0
else

   #4. install-helm.sh
   echo
   log_message "***************     Installing Helm"
   bash "./$ES_file_helm"
   if [ $? != 0 ]; then
      log_message "*************** $ES_file_helm Failed, Exiting!"
      exit 1
   fi

   #5. Adding Shield Repo
   echo
   log_message "***************     Adding Shield Repo"
   source "./$ES_file_addrepo" $@ -s
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
fi

#7.    Move to Default
