#!/bin/bash
############################################
#####   Ericom Shield showmyIP         #####
#######################################BH###

IP=$(/sbin/ifconfig | grep 'inet addr:' | grep -v "127.0" | grep -v "172.1" | cut -d: -f2 | awk '{ print $1}')

echo "***********       "
echo "                  Ericom Shield"
echo "                  xxxxxxxxxxxxx"
echo "                  "
echo "                  Server IP Address: $IP "
echo "***********       "
