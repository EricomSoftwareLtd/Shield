FROM python:3.6.5-slim-jessie

RUN apt-get update && apt-get install -y libltdl7
RUN pip install --upgrade pip

COPY scripts /scripts
COPY setup-node.sh /
COPY requirements.txt /
COPY install-docker.sh /
COPY mount-tmpfs-volume.sh /
COPY sysctl_shield.conf /

RUN pip install -r requirements.txt
