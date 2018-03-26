FROM securebrowsing/secure-remote-browser-ubuntu-base:latest_2


RUN apt-get update && apt-get install -y --no-install-recommends python-pip python-setuptools \
    && pip install --upgrade pip


COPY scripts /scripts
COPY setup-node.sh /
COPY requirements.txt /
COPY install-docker.sh /
COPY mount-tmpfs-volume.sh /
COPY sysctl_shield.conf /

RUN pip install -r requirements.txt
