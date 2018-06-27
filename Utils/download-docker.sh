#!/bin/bash -ex
############################################
#####   Ericom Shield Docker Installer #####
####################################AN#BH###

DOCKER_VERSION="18.03.0~ce*"

sudo apt-get --assume-yes -y install apt-transport-https software-properties-common

# Add Docker repo
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Create docker_debs empty dir if necessary
if [ ! -d ./docker_debs ]; then
    mkdir -p ./docker_debs
    chmod 0755 ./docker_debs
fi

PACKAGES="docker-ce=${DOCKER_VERSION} uuid-runtime curl \
        libgnutls-openssl27 libpam-systemd systemd udev"

sudo apt update

cd  ./docker_debs && \
    rm -f *.deb && \
    apt-get download $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances ${PACKAGES} | grep "^\w" | grep -v ":i386$" | sed "s#docker-ce#docker-ce=${DOCKER_VERSION}#") && \
    cd ..

tar cvfz docker-debs.tgz ./docker_debs
