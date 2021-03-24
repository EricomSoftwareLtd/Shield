#!/bin/sh -ex

export RANCHER_CONTAINER_ID=$(docker ps | grep -oP '\w+(?=\s+rancher/rancher)') #'
docker container restart $RANCHER_CONTAINER_ID

docker exec -it $RANCHER_CONTAINER_ID sh -c 'mv /var/lib/rancher/k3s/server/tls /var/lib/rancher/k3s/server/tls.$(date -Iseconds)'
docker container restart $RANCHER_CONTAINER_ID
sleep 150
docker container restart $RANCHER_CONTAINER_ID
