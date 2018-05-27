#!/bin/bash
############################################
#####   Ericom Shield showmyIP         #####
#######################################BH###

echo "Ericom Shield System ID:"
docker container exec $(docker ps --filter name=broker -q) cat /run/secrets/shield-system-id
