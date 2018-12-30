#!/bin/sh -e

ES_GH_REL="$1"
DOCKERURL="$2"

if [ -z "${ES_GH_REL}" ]; then
    echo "Usage: $0 [VERSION] [DOCKERURL]"
    echo "          VERSION - Release version, e.g. Dev460.1"
    echo "          DOCKERURL - optional URL of Docker EE (for RHEL)"
    exit 1
fi

set -x

if [ -x /sbin/subscription-manager ]; then
    sudo subscription-manager repos --enable="rhel-*-optional-rpms" --enable="rhel-*-extras-rpms" --enable="rhel-*-ansible-2.7-rpms"
    rpm -q epel-release || sudo yum install -y "https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm"

    sudo yum install -y yum-utils device-mapper-persistent-data lvm2

    if ! [ -z "$DOCKERURL" ]; then
        sudo rm -f /etc/yum.repos.d/docker*.repo
        sudo -E sh -c "echo \"$DOCKERURL/rhel\" > /etc/yum/vars/dockerurl"
        sudo sh -c 'echo "7" > /etc/yum/vars/dockerosversion'
        sudo -E yum-config-manager --add-repo "$DOCKERURL/rhel/docker-ee.repo"
        sudo -E yum-config-manager --enable docker-ee-stable
    fi

    sudo yum install "https://github.com/EricomSoftwareLtd/Shield/releases/download/${ES_GH_REL}/ericom_shield.rhel.x86_64.rpm"

else
    sudo yum install -y epel-release

    sudo yum install -y yum-utils device-mapper-persistent-data lvm2

    sudo yum-config-manager --add-repo "https://download.docker.com/linux/centos/docker-ce.repo"
    sudo yum-config-manager --disable docker-ce-edge
    sudo yum-config-manager --disable docker-ce-test

    sudo yum install "https://github.com/EricomSoftwareLtd/Shield/releases/download/${ES_GH_REL}/ericom_shield.centos.x86_64.rpm"
fi

sudo /usr/local/ericomshield/setup.sh
