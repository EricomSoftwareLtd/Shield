#!/bin/bash -ex

source common

#helm install rancher-stable/rancher \
#  --name rancher \
#  --namespace cattle-system \
#  --set hostname=$HOSTNAME

helm install rancher-stable/rancher \
    --name rancher \
    --namespace cattle-system \
    --set hostname=$HOSTNAME \
    --set ingress.tls.source=secret \
    --set privateCA=true \
#    --set additionalTrustedCAs=true

kubectl -n cattle-system delete secret tls-ca || :
kubectl -n cattle-system delete secret tls-rancher-ingress || :
kubectl -n cattle-system create secret generic tls-ca --from-file=cacerts.pem
kubectl -n cattle-system create secret tls tls-rancher-ingress --cert=cert.crt --key=cert.key

kubectl -n cattle-system rollout status deploy/rancher
