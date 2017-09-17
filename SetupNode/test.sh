#!/bin/bash -x



IFS=',' read -r -a array <<< "$@"


for ip in "${array[@]}"; do
    echo "$ip"
done