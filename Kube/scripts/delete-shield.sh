#!/bin/bash
############################################
#####   Ericom Shield Delete Shield   #####
#######################################BH###

SHIELD="shield"

COMPONENTS=(farm-services proxy management elk)

read -p "Are you sure you want to delete the deployment? " choice
case "$choice" in
y | Y | "yes" | "YES" | "Yes")
    echo "yes"
    echo "***************     Uninstalling $SHIELD"
    for component in "${COMPONENTS[@]}"; do
        helm delete --purge "shield-${component}"
        kubectl delete namespace "${component}"
    done
    ;;
*)
    echo "no"
    echo "Ok!"
    ;;
esac
