#!/bin/bash -ex

for file in $(ls *.sh); do
    shfmt -i 4 -ln bash -s -w "$file"
    echo "$file"
done
