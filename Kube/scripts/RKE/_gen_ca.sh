#!/bin/bash -ex

source common

openssl genrsa -out cacerts.key 4096
openssl req -x509 -new -nodes -key cacerts.key -subj "/C=IL/ST=IL/O=Ericom/CN=Ericom Shield CA" -sha256 -days 3650 -out cacerts.pem
