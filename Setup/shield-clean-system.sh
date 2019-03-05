#!/bin/bash

docker system prune -af
filename=./shield-version.txt
COUNTER=0
while read -r line; do
    if [ "$COUNTER" -ge "2" ]; then
        arr=($line)
        docker pull "securebrowsing/${arr[1]}"
        docker tag "securebrowsing/${arr[1]}" "securebrowsing/${arr[0]}"
    fi
    COUNTER=$((COUNTER + 1))
done <"$filename"
