#!/usr/bin/sudo /bin/bash

set -e
set -x

DATE_ORIG="$(date -d 'now' '+%F %T')"
DATE_ORIG_ISO="$(date -Iseconds)"
DATE_PAST="$(date -d 'now - 2 months' '+%F %T')"

function cleanup()
{
    timedatectl set-ntp off
    timedatectl set-time "$DATE_ORIG"
    timedatectl set-ntp on
}

trap cleanup EXIT

RANCHER_CONTAINER_ID=$(docker ps | grep -oP '\w+(?=\s+rancher/rancher:)') #'

timedatectl set-ntp off
timedatectl set-time "$DATE_PAST"

docker exec -it $RANCHER_CONTAINER_ID sh -c "mv /var/lib/rancher/k3s/server/tls /var/lib/rancher/k3s/server/tls.${DATE_ORIG_ISO}"
docker container restart $RANCHER_CONTAINER_ID
sleep 150
docker container restart $RANCHER_CONTAINER_ID
sleep 150
cleanup
docker container restart $RANCHER_CONTAINER_ID
