#!/bin/bash
############################################
#####   Ericom Shield Delete Shield   #####
#######################################BH###

SHIELD="shield"

read -p "Are you sure you want to delete the deployment?" choice;
   case "$choice" in
     y | Y | "yes" | "YES" | "Yes")
         echo "yes"
         echo "***************     Uninstalling $SHIELD"
         helm delete --purge shield-management
         helm delete --purge shield-proxy
         helm delete --purge shield-farm-services
         helm delete --purge shield-elk
         ;;
     *)
         echo "no"
         echo "Ok!"
         ;;
     esac
