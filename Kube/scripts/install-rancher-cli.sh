#!/bin/bash
############################################
#####   Ericom Shield: Install Rancher CLI #
#######################################BH###

NOT_FOUND_STR="404: Not Found"
STEP_BY_STEP="false"
ES_PATH="$HOME/ericomshield"
LOGFILE="$ES_PATH/ericomshield.log"
RANCHER_CLI="false"
RANCHER_CLI_VERSION="v2.3.2"
ES_repo_rancher_cli="https://github.com/rancher/cli/releases/download/$RANCHER_CLI_VERSION/rancher-linux-amd64-$RANCHER_CLI_VERSION.tar.xz"
ES_file_rancher_cli="rancher-linux-amd64-$RANCHER_CLI_VERSION.tar.xz"
ES_file_cluster_config="cluster.json"

function usage() {
     echo " Usage: $0 [-h|--help]"
}

#Check if we are root
if ((EUID != 0)); then
    # sudo su
    usage
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

function log_message() {
    local PREV_RET_CODE=$?
    echo "$@"
    echo "$(LC_ALL=C date): $@" >>"$LOGFILE"
    if ((PREV_RET_CODE != 0)); then
        return 1
    fi
    return 0
}

function install_if_not_installed() {
    if ! dpkg -s "$1" >/dev/null 2>&1; then
        echo "***************     Installing $1"
        apt-get --assume-yes -y install "$1"
    fi
}

function install_rancher_cli() {
    if ! which rancher >/dev/null; then
        pushd "$(mktemp -d)"
        wget "$ES_repo_rancher_cli"
        tar xf "$ES_file_rancher_cli"
        mv rancher-*/rancher /usr/bin/
        rm -rf rancher-*
        popd
    fi
}

##################      MAIN: EVERYTHING STARTS HERE: ##########################
log_message "***************     Installing Rancher CLI ..."

install_if_not_installed jq

install_rancher_cli

log_message "***************     Done !!!"