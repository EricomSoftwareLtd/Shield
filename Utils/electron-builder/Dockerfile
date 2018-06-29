FROM ubuntu:18.04
MAINTAINER Andrew Novikov <Andrew.Novikov@artezio.com>

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y build-essential clang libdbus-1-dev libgtk-3-dev \
                       libnotify-dev libgnome-keyring-dev libgconf2-dev \
                       libasound2-dev libcap-dev libcups2-dev libxtst-dev \
                       libxss1 libnss3-dev gcc-multilib g++-multilib curl \
                       gperf bison \
                       bash apt-utils git nodejs npm

RUN useradd -m --shell /bin/bash user
