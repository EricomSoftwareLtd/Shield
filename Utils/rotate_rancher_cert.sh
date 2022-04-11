#!/usr/bin/sudo /bin/bash

set -e
set -x

export LC_TIME=C

DATE_ORIG="$(date -d 'now' '+%F %T')"
DATE_ORIG_ISO="$(date -Iseconds)"
CERT_END_DATE="$(openssl x509 -noout -enddate -in "/home/ericom/ericomshield/rancher-store/k3s/server/tls/client-admin.crt" | sed -E 's/notAfter=(.*)/\1/')"
DATE_PAST="$(date -d "$CERT_END_DATE - 1 months" '+%F %T')"

function cleanup() {
    timedatectl set-ntp off
    timedatectl set-time "$DATE_ORIG"
    timedatectl set-ntp on
}

trap cleanup EXIT

RANCHER_CONTAINER_ID=$(docker ps | grep 'rancher/rancher:' | awk '{print $1}')

docker exec -it $RANCHER_CONTAINER_ID sh -c "kubectl delete secret -n kube-system k3s-serving --insecure-skip-tls-verify" || :

timedatectl set-ntp off
timedatectl set-time "$DATE_PAST"

docker container restart $RANCHER_CONTAINER_ID
sleep 150
cleanup
docker exec -it $RANCHER_CONTAINER_ID sh -c "mv /var/lib/rancher/k3s/server/tls/dynamic-cert.json /var/lib/rancher/k3s/server/tls/dynamic-cert.json.${DATE_ORIG_ISO}" || :
docker container restart $RANCHER_CONTAINER_ID
