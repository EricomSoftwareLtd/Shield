#!/bin/bash
############################################
#####   Ericom Shield showmyIP         #####
#######################################BH###

IP="$(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p')"
if [ -z "$IP" ]; then
    IP="$(hostname -I | cut -d' ' -f1)"
fi

echo "***********       "
echo "                  Ericom Shield"
echo "                  xxxxxxxxxxxxx"
echo "                  "
echo "                  Server IP Address: $IP "
echo "***********       "
