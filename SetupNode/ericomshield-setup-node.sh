#!/bin/bash
############################################
#####   Ericom Shield Installer        #####
#######################################BH###

IS_MANAGER=


while [ $# -ne 0 ]
do
    arg="$1"
    case "$arg" in
        -m|--manager)
            IS_MANAGER=yes
            ;;
        *)
            echo "Usage:" $0 [-force] [-noautoupdate] [-dev] [-pocket] [-usage]
            exit
            ;;
    esac
    shift
done


function check_or_install_docker {
    if [ $(sudo docker version | grep $DOCKER_VERSION |wc -l ) -le  1 ]; then
         echo "***************     Installing docker-engine"
         apt-get --assume-yes -y install apt-transport-https
         apt-get update
         apt-get --assume-yes -y  install apt-transport-https ca-certificates software-properties-common
         curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
         add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
         apt-get update
         apt-get --assume-yes -y install docker-ce
    else
         echo " ******* docker-engine is already installed"
    fi
    if [ $(sudo docker version |wc -l ) -le  1 ]; then
       echo "Failed to install docker, Exiting!"
       echo "$(date): An error occured during the installation: Cannot login to docker" >> "$LOGFILE"
       exit 1
    fi
}


check_or_install_docker

