#!/bin/bash -ex

############################################
#####   Ericom Shield Proxy AppImage   #####
####################################AN#BH###

DIR="$(dirname "$(readlink -f "${0}")")" #"

APPIMAGE="shield-prepare-servers"

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

docker build -t "$DOCKER_SSHPASS_BUILDER_IMG_TAG" -f "${DIR}/Docker/Dockerfile.sshpass" "${DIR}/Docker"
docker build -t "$DOCKER_CONDA_BUILDER_IMG_TAG" -f "${DIR}/Docker/Dockerfile.conda" "${DIR}/Docker"

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
cp -r "$DIR/ansible_playbooks" "$DIR/shield-prepare-servers.py" "$DIR/add-registry.py" "$APPIMAGE_DIR"

"$APPIMAGETOOL" "$APPIMAGE_DIR" "$APPIMAGE"

rm -rf "$APPIMAGE_DIR"
