#!/bin/bash -ex

############################################
#####   Ericom Shield Proxy AppImage   #####
####################################AN#BH###

DIR="$(dirname "$(readlink -f "${0}")")" #"

APPIMAGE="preparenode-x86_64.AppImage"

APPIMAGETOOL_URL="https://github.com/AppImage/AppImageKit/releases/download/12/appimagetool-x86_64.AppImage"
APPIMAGETOOL="/tmp/appimagetool-x86_64.AppImage"

DOCKER_SSHPASS_BUILDER_IMG_TAG="ericom_sshpass_builder:latest"
DOCKER_CONDA_BUILDER_IMG_TAG="ericom_conda_builder:latest"

if ! [ -x "$APPIMAGETOOL" ]; then
    wget -O "$APPIMAGETOOL" -nc "$APPIMAGETOOL_URL"
    chmod +x "$APPIMAGETOOL"
fi

APPIMAGE_DIR="$(mktemp -d)" || {
    echo "Failed to create AppDir"
    exit 1
}

cp "$DIR/AppRun" "$DIR/EricomShield.desktop" "$DIR/EricomShield.svg" "$APPIMAGE_DIR"

if ! docker image inspect "$DOCKER_SSHPASS_BUILDER_IMG_TAG" >/dev/null 2>&1; then
    docker build -t "$DOCKER_SSHPASS_BUILDER_IMG_TAG" -f "${DIR}/Docker/Dockerfile.sshpass" "${DIR}/Docker"
fi
if ! docker image inspect "$DOCKER_CONDA_BUILDER_IMG_TAG" >/dev/null 2>&1; then
    docker build -t "$DOCKER_CONDA_BUILDER_IMG_TAG" -f "${DIR}/Docker/Dockerfile.conda" "${DIR}/Docker"
fi

docker run --user "$(id -u):$(id -g)" \
    -v "$APPIMAGE_DIR:/AppDir2" \
    --rm \
    -w "/tmp" \
    "$DOCKER_SSHPASS_BUILDER_IMG_TAG" cp -dR /AppDir/. /AppDir2

docker run --user "$(id -u):$(id -g)" \
    -v "$APPIMAGE_DIR:/AppDir2" \
    --rm \
    -e "CONDA_PKGS_DIRS=/Packages" \
    -e "CONDA_ENVS_PATH=/AppDir" \
    -w "/tmp" \
    "$DOCKER_CONDA_BUILDER_IMG_TAG" cp -dR /AppDir/. /AppDir2

#cp -T "$DIR/../proxy3.py" "$APPIMAGE_DIR/usr/bin/proxy.py"
cp "$DIR/disable_firewalld.yaml" "$DIR/prepare_node_playbook.yaml" "$DIR/prepare_node_tasks.yaml" "$DIR/daemon.json" "$DIR/../scripts/configure-sysctl-values.sh" "$DIR/prepare_node.py" "$APPIMAGE_DIR"

"$APPIMAGETOOL" "$APPIMAGE_DIR" "$APPIMAGE"

rm -rf "$APPIMAGE_DIR"
