#!/usr/bin/sudo /bin/bash

set -e
set -x

export LC_TIME=C
DATE_ORIG="$(date -d 'now' '+%F %T')"

function cleanup() {
    timedatectl set-ntp off
    timedatectl set-time "$DATE_ORIG"
    timedatectl set-ntp on
}

RANCHER_CONTAINER_ID=$(docker ps | grep 'rancher/rancher:' | awk '{print $1}')

if [[ -z "$RANCHER_CONTAINER_ID" ]]; then
    echo "Could not find Rancher container"
    exit 1
fi

RANCHER_IMAGE_VERSION=$(docker exec -it $RANCHER_CONTAINER_ID sh -c 'echo -n $CATTLE_SERVER_VERSION | grep -oE "v[0-9]+\.[0-9]+"')

if [[ "$RANCHER_IMAGE_VERSION" =~ ^v2\.4 ]]; then

    DATE_ORIG_ISO="$(date -Iseconds)"
    CERT_END_DATE="$(openssl x509 -noout -enddate -in "/home/ericom/ericomshield/rancher-store/k3s/server/tls/client-admin.crt" | sed -E 's/notAfter=(.*)/\1/')"
    DATE_BEFORE_CERT_END="$(date -d "$CERT_END_DATE - 1 months" '+%F %T')"

    trap cleanup EXIT

    docker exec -it $RANCHER_CONTAINER_ID sh -c "mv /var/lib/rancher/k3s/server/tls/dynamic-cert.json /var/lib/rancher/k3s/server/tls/dynamic-cert.json.${DATE_ORIG_ISO}" || :
    docker exec -it $RANCHER_CONTAINER_ID sh -c 'kubectl delete secret -n kube-system k3s-serving --insecure-skip-tls-verify; kubectl delete secret -n cattle-system serving-cert --insecure-skip-tls-verify' || :

    timedatectl set-ntp off
    timedatectl set-time "$DATE_BEFORE_CERT_END"

    docker container restart $RANCHER_CONTAINER_ID
    sleep 60
    cleanup
    docker container restart $RANCHER_CONTAINER_ID
    sleep 60
    echo "Inforation on the validity of Rancher certificates:"
    docker exec -it $RANCHER_CONTAINER_ID bash -c 'cd /var/lib/rancher/k3s/server/tls && for i in $(ls *.crt); do echo $i; openssl x509 -noout -startdate -enddate -in $i; done' || :
    echo "Rancher k3s certificate validity information:"
    docker exec -it $RANCHER_CONTAINER_ID sh -c 'openssl s_client -connect localhost:6443 -showcerts </dev/null 2>&1 | openssl x509 -noout -startdate -enddate' || :
    echo "Rancher UI certificate validity information:"
    docker exec -it $RANCHER_CONTAINER_ID sh -c 'openssl s_client -connect localhost:443 -showcerts </dev/null 2>&1 | openssl x509 -noout -startdate -enddate' || :

else

    docker exec -it $RANCHER_CONTAINER_ID sh -c 'mv /var/lib/rancher/k3s/server/tls /var/lib/rancher/k3s/server/tls.$(date -Iseconds)'
    docker container stop $RANCHER_CONTAINER_ID
    # sleep 150
    docker container rm -f $RANCHER_CONTAINER_ID
    
    export HOME="/home/ericom"
    "$HOME/ericomshield/run-rancher.sh"

fi
