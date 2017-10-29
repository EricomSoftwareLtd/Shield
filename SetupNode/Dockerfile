FROM python:3.6.3-jessie


RUN apt-get update \
    && pip install --upgrade pip


COPY scripts /scripts
COPY setup-node.sh /
COPY requirements.txt /
COPY install-docker.sh /
COPY mount-tmpfs-volume.sh /

RUN pip install -r requirements.txt
