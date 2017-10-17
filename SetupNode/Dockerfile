FROM python:3.6.3-jessie


RUN apt-get update \
    && apt-get install sshpass


COPY scripts /scripts
COPY setup-node.sh /



CMD ["./setup-node.sh"]