#!/bin/sh -ex

sudo yum install -y yum-utils \
    device-mapper-persistent-data \
    lvm2

sudo yum-config-manager --add-repo "https://download.docker.com/linux/centos/docker-ce.repo"
sudo yum-config-manager --disable docker-ce-edge
sudo yum-config-manager --disable docker-ce-test

sudo yum install -y epel-release

# sudo yum install docker-ce
