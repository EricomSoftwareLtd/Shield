#!/bin/bash


if [ -n "$1" ]; then
    TAG="$1"
else
    TAG=`date +"%y%m%d-%H.%M"`
fi

docker tag securebrowsing/node-installer:latest securebrowsing/node-installer:$TAG

docker push securebrowsing/node-installer:$TAG