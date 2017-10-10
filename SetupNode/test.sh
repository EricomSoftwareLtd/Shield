#!/bin/bash -x

LEADER_IP=10.0.0.1:2377


make_leader_hosts_record() {
     IFS=':' read -r -a array <<< "$LEADER_IP"
     CLEAN_IP="${array[0]}"
     CLEAN_HOST=$(hostname)

     echo "$CLEAN_IP    $CLEAN_HOST"
}


NU=$(make_leader_hosts_record)

sshpass -pEricom123$ ssh -o StrictHostKeyChecking=no -q ericom@10.0.0.101 <<- EOF
    sudo su
    echo "$NU" >> /etc/hosts
    cat /etc/hosts
EOF