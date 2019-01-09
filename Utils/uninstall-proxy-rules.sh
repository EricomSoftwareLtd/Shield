#!/bin/bash -e
#####################################################
#####   Ericom Shield Proxy Rules uninstall     #####
#############################################AN#BH###

ES_PATH="/usr/local/ericomshield"

function show_usage() {
    echo ""
    echo "Shield IP tables rules uninstallation"
    echo "   Usage: $0"
    echo ""
    exit
}

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo " Please run it as Root"
    echo "sudo $0 $@"
    show_usage
    exit 1
fi

if [ $(systemctl status es-iptables-rule.service | grep -c 'Loaded: not-found') -eq "1" ]; then
    echo "es-iptables-rule.service is not installed."
    exit 1
else
    $ES_PATH/delete-iptable-rules.sh
    systemctl stop es-iptables-rule.service
    systemctl --system disable es-iptables-rule.service
    rm -f $ES_PATH/create-iptable-rules.sh
    rm -f $ES_PATH/delete-iptable-rules.sh
    rm -f $ES_PATH/es-iptables-rule.service
fi

echo "es-iptables-rule.service was uninstalled."
