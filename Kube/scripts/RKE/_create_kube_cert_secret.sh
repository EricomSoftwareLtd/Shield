#!/bin/bash -ex

source common

kubectl -n cattle-system delete secret tls-ca || :
# kubectl -n cattle-system delete secret tls-ca-additional || :
kubectl -n cattle-system delete secret tls-rancher-ingress || :
kubectl -n cattle-system create secret generic tls-ca --from-file=cacerts.pem
# kubectl -n cattle-system create secret generic tls-ca-additional --from-file=cacerts.pem
kubectl -n cattle-system create secret tls tls-rancher-ingress --cert=cert.crt --key=cert.key
