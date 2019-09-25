FROM centos:centos7.6.1810

MAINTAINER Andrew Novikov <Andrew.Novikov@artezio.com>

RUN yum install -y centos-packager @development-tools
RUN yum install -y epel-release \
    && yum install -y python36-devel

RUN useradd -m --shell "/bin/bash" -G "mock" user
