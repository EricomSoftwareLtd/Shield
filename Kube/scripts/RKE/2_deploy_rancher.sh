#!/bin/bash -ex

source common

helm install rancher-stable/rancher \
    --name rancher \
    --namespace cattle-system \
    --set hostname=$RANCHER_LB_HOSTNAME \
    --set ingress.tls.source=secret \
    --set privateCA=true \

kubectl -n cattle-system delete secret tls-ca || :
kubectl -n cattle-system delete secret tls-rancher-ingress || :
kubectl -n cattle-system create secret generic tls-ca --from-file=cacerts.pem
kubectl -n cattle-system create secret tls tls-rancher-ingress --cert=cert.crt --key=cert.key

kubectl -n cattle-system rollout status deploy/rancher
