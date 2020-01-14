#!/bin/bash
############################################
#####   Ericom Shield Cleanup Old RBs  #####
#######################################BH###

echo "Total Browsers (Before):"
docker ps | grep -c browser
docker ps | grep -c weeks | grep browser
docker ps | grep weeks | grep browser | awk '{print $1 }' | xargs --no-run-if-empty sudo docker rm -f
docker ps | grep -c days | grep browser
docker ps | grep days | grep browser | awk '{print $1 }' | xargs --no-run-if-empty sudo docker rm -f
echo "Total Browsers (After Cleaning Olds):"
docker ps | grep -c browser

docker ps -a | grep browser |awk '{print $1 }' > myrb.txt

while read -r id; do
  if [ $( docker logs $id | grep -c terminated) -ge 1 ]; then
    echo killing $id
    docker logs $id >> killed-rb.logs
    docker rm -f $id
  fi
done < myrb.txt

echo "Total Browsers (After cleaning Terminated):"
docker ps | grep -c browser

