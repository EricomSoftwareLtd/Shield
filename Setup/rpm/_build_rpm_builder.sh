#!/bin/bash -ex

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" #"
source "${DIR}/common"

cd "$DIR"

docker build -t "$DOCKER_RPM_BUILDER_IMG_TAG" .
