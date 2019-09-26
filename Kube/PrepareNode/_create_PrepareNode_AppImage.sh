#!/bin/bash -ex

############################################
#####   Ericom Shield Proxy AppImage   #####
####################################AN#BH###

DIR="$(dirname "$(readlink -f "${0}")")" #"

APPIMAGE="preparenode-x86_64.AppImage"

APPIMAGETOOL_URL="https://github.com/AppImage/AppImageKit/releases/download/12/appimagetool-x86_64.AppImage"
APPIMAGETOOL="/tmp/appimagetool-x86_64.AppImage"

if ! [ -x "$APPIMAGETOOL" ]; then
    wget -O "$APPIMAGETOOL" -nc "$APPIMAGETOOL_URL"
    chmod +x "$APPIMAGETOOL"
fi

APPIMAGE_DIR="$(mktemp -d)" || {
    echo "Failed to create AppDir"
    exit 1
}

CONDAPKGS_DIR="$(mktemp -d)" || {
    echo "Failed to create a temporary directory for Conda"
    exit 1
}

cp "$DIR/AppRun" "$DIR/EricomShield.desktop" "$DIR/EricomShield.svg" "$APPIMAGE_DIR"
docker run --user "$(id -u):$(id -g)" \
    -v "$APPIMAGE_DIR:/AppDir" \
    -v "$APPIMAGE_DIR:/.conda" \
    -v "$CONDAPKGS_DIR:/Packages" \
    --rm \
    -e "CONDA_PKGS_DIRS=/Packages" \
    -e "CONDA_ENVS_PATH=/AppDir" \
    -w "/tmp" \
    continuumio/miniconda3 conda create -p /AppDir/usr -c conda-forge ansible --copy --no-default-packages -y

#cp -T "$DIR/../proxy3.py" "$APPIMAGE_DIR/usr/bin/proxy.py"

"$APPIMAGETOOL" "$APPIMAGE_DIR" "$APPIMAGE"

rm -rf "$APPIMAGE_DIR"
rm -rf "$CONDAPKGS_DIR"
