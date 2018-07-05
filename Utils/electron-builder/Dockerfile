FROM ubuntu:18.04
MAINTAINER Andrew Novikov <Andrew.Novikov@artezio.com>

ENV ELECTRON_BRANCH="3-0-x"

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y build-essential clang libdbus-1-dev libgtk-3-dev \
                       libnotify-dev libgnome-keyring-dev libgconf2-dev \
                       libasound2-dev libcap-dev libcups2-dev libxtst-dev \
                       libxss1 libnss3-dev gcc-multilib g++-multilib curl \
                       gperf bison \
                       bash apt-utils git nodejs npm

RUN useradd -m --shell /bin/bash user

USER user

RUN mkdir /home/user/workdir && \
    cd /home/user/workdir && \
    git clone "https://github.com/electron/electron" && \
    cd electron && \
    git checkout "${ELECTRON_BRANCH}"

RUN cd /home/user/workdir/electron && \
    ./script/bootstrap.py --verbose

COPY patches/ /home/user/patches/
RUN cd /home/user/workdir/electron && \
    ls /home/user/patches/*.diff | xargs -n1 patch -p1 -i

RUN cd /home/user/workdir/electron && \
    ./script/build.py && \
    ./script/create-dist.py

USER root
