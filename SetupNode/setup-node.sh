#!/bin/bash


setup-envinronment() {
    if [ -f '.stoperror' ]; then
        rm -f .stoperror
    fi

    python scripts/make_env.py "${@}"
    if [ -f .env ]; then
        source .env
    else
        if [ ! -f '.stoperror' ]; then
            echo "No enviroment file generated"
            exit 1
        else
            exit 0
        fi
    fi
}

prepare_remote_machines() {
    counter=1
    for ip in $MACHINE_IPS; do
        python scripts/prepare_remote_machine.py $ip
        counter=$(($counter + 1))
    done
}

run_with_password() {
    read -s -p "Machine user Password: " MACHINE_USER_PASS
    echo " "
    read -s -p "Retype user Password: " RETYPE_PASSWORD
    if [ "$MACHINE_USER_PASS" = "$RETYPE_PASSWORD" ]; then
        export MACHINE_USER_PASS=$MACHINE_USER_PASS
        prepare_remote_machines
    else
        echo "Password is wrong"
        run_with_password
    fi
}


echo "##################################### Setup Ericomshield nodes #############################################"
set -e
setup-envinronment "$@"
set +e

if [ "$MACHINE_SESSION_MODE" = "password" ]; then
    run_with_password
else
    prepare_remote_machines
fi

python scripts/print_final_report.py
