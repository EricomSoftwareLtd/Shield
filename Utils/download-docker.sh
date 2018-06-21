#!/bin/bash -ex
############################################
#####   Ericom Shield Docker Installer #####
####################################AN#BH###

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo "Usage: $0"
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi

# Create docker_debs empty dir if necessary
if [ ! -d ./docker_debs ]; then
    mkdir -p ./docker_debs
    chmod 0755 ./docker_debs
fi

PACKAGES="docker-ce=18.03.0~ce* uuid-runtime curl"

sudo apt update

cd  ./docker_debs && \
    rm -f *.deb && \
    apt-get download $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances --no-pre-depends ${PACKAGES} | grep "^\w") && \
    rm -f *i386.deb && \
    cd ..

tar cvfz docker-debs.tgz ./docker_debs
