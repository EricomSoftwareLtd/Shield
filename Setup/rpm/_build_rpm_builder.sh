#!/bin/sh -ex

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" #"

if [ -z "$1" ]; then
    IMAGE_NAME_TAG="shield_rpmbuilder:latest"
else
    IMAGE_NAME_TAG="$1"
fi

cd "$DIR"

docker build -t "${IMAGE_NAME_TAG}" .
