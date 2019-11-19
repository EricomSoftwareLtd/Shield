#!/bin/bash -ex

source common

openssl genrsa -out cert.key 2048
openssl req -new -sha256 -key cert.key -subj "/C=IL/ST=IL/O=Ericom/CN=$RANCHER_LB_HOSTNAME" -out cert.csr
openssl x509 -req -in cert.csr -CA cacerts.pem -CAkey cacerts.key -CAcreateserial -out cert.crt -days 3650 -sha256
