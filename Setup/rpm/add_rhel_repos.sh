#!/bin/sh -ex

DOCKERURL="$1"

sudo subscription-manager repos --enable="rhel-*-optional-rpms" --enable="rhel-*-extras-rpms" --enable="rhel-*-ansible-2.7-rpms"
sudo yum install -y "https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm"

sudo yum install -y yum-utils device-mapper-persistent-data lvm2

if ! [ -z "$DOCKERURL" ]; then
    sudo rm /etc/yum.repos.d/docker*.repo
    sudo -E sh -c "echo \"$DOCKERURL/rhel\" > /etc/yum/vars/dockerurl"
    sudo sh -c 'echo "7" > /etc/yum/vars/dockerosversion'
    sudo -E yum-config-manager --add-repo "$DOCKERURL/rhel/docker-ee.repo"
fi

# sudo yum install docker-ee
