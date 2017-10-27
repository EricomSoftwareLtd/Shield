#!/bin/bash


setup-envinronment() {
    python scripts/make_env.py "${@}"
    if [ -f .env ]; then
        source .env
    else
        echo "No enviroment file generated"
        exit 1
    fi
}

prepare_remote_machines() {
    counter=1
    for ip in $MACHINE_IPS; do
        export REMOTE_HOST_NAME="$MACHINE_NAME_PREFIX$counter"
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
    echo "Will run with certificate"
fi

python scripts/print_final_report.py
