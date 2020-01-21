#!/bin/bash -ex

source common

kubectl -n kube-system create serviceaccount tiller

kubectl create clusterrolebinding tiller \
    --clusterrole=cluster-admin \
    --serviceaccount=kube-system:tiller

helm init --service-account tiller

# Users in China: You will need to specify a specific tiller-image in order to initialize tiller.
# The list of tiller image tags are available here: https://dev.aliyun.com/detail.html?spm=5176.1972343.2.18.ErFNgC&repoId=62085.
# When initializing tiller, you'll need to pass in --tiller-image

# helm init --service-account tiller \
#  --tiller-image registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:<tag>

kubectl -n kube-system rollout status deploy/tiller-deploy
kubectl --namespace=kube-system wait --for=condition=Available --timeout=5m apiservices/v1beta1.metrics.k8s.io
