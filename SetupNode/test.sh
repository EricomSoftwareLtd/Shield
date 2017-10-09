#!/bin/bash -x

MACHINE_USER_PASS=

command_exists() {
	command -v "$@" > /dev/null 2>&1
}


append-sshpass() {
    if ! command_exists sshpass; then
        sudo apt-get install -y --assume-yes sshpass
    fi
}


collect_machine_pass() {
    echo "Remote machine password:"
    read MACHINE_USER_PASS
}



append-sshpass


sshpass -p$MACHINE_USER_PASS ssh -o StrictHostKeyChecking=no ericom@10.0.0.103 sudo cat /etc/sudoers