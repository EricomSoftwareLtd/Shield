#!/bin/bash
############################################
#####   Ericom Shield Monitor Systems    ###
#######################################BH###

## declare an array variable
declare -a ShieldSystemsNames=(
#"ES-Dev-Staging"
#"ES-Dev-Jer"
"ES-Dev-Modiin"
"ES-Dev-Load"
"ES-Dev-RO"
"ES-Prod-Jer"
"ES-Prod-Modiin"
"ES-Prod-US"
"ES-Prod-UK"
"ES-Prod-UK-Azure"
"ES-Prod-RO"
"")
declare -a ShieldSystemsIPs=(
#"126.0.1.140"
#"126.0.3.123"
"192.168.50.115"
"126.0.7.17"
"192.168.1.140"
"126.0.0.240"
"192.168.50.126"
"192.168.35.98"
"131.107.2.112"
"51.140.76.130"
"192.168.1.249"
"")

t=0
## now loop through the above array
for IP in "${ShieldSystemsIPs[@]}"
do
   Name="${ShieldSystemsNames[t]}"

   if [ ! -z $Name ] ;  then
      echo "Checking Shield: $Name: $IP"
#   if [ $(ping -c 1 $IP | grep -c ttl) -eq 1 ]; then
      rm -f "status_$Name.txt"
      curl -s -q --proxy http://$IP:3128 http://shield-ver > "status_$Name.txt" &
#     else
#      echo "No answer on Ping"
   fi
   echo
   let t=t+1
done
echo "."
sleep 5
echo "."

t=0
Name="${ShieldSystemsNames[t]}"
IP="${ShieldSystemsIPs[t]}"
while [ ! -z $Name ] ; do
   echo "$Name - ($IP):"
   if [ -f "status_$Name.txt" ]; then
      if [ $(grep -c "running" "status_$Name.txt") -eq 1 ]; then
        cat "status_$Name.txt"
       else
        echo "$Name: Error: Check status_$Name.txt"
      fi
     else
       echo "$Name: Error: No Answer"
   fi

   echo
   let t=t+1
   Name="${ShieldSystemsNames[t]}"
   IP="${ShieldSystemsIPs[t]}"
done
