#!/bin/sh -ex

: ${DEV_IMAGE_TAG:="latest"} # default DEV_IMAGE_TAG
IMAGE_NAME_TAG="shield_rpmbuilder:${DEV_IMAGE_TAG}"

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" #"

cd "$DIR"

docker build -t "${IMAGE_NAME_TAG}" .
