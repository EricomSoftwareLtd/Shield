#!/bin/bash -ex

############################################
#####   Ericom Shield Proxy AppImage   #####
####################################AN#BH###

DIR="$(dirname "$(readlink -f "${0}")")" #"

APPIMAGE="proxy-x86_64.AppImage"

APPIMAGETOOL_URL="https://github.com/AppImage/AppImageKit/releases/download/12/appimagetool-x86_64.AppImage"
APPIMAGETOOL="/tmp/appimagetool-x86_64.AppImage"

wget -O "$APPIMAGETOOL" -nc "$APPIMAGETOOL_URL"
chmod +x "$APPIMAGETOOL"

APPIMAGE_DIR="$(mktemp -d)" || {
    echo "Failed to create AppDir"
    exit 1
}

cp "$DIR/AppRun" "$DIR/EricomShield.desktop" "$DIR/EricomShield.svg" "$APPIMAGE_DIR"
docker run -v "$APPIMAGE_DIR:/AppDir" --rm continuumio/miniconda3 conda create -p AppDir/usr python --copy --no-default-packages -y
"$APPIMAGETOOL" "$APPIMAGE_DIR" "$APPIMAGE"

#rm -rf "$APPIMAGE_DIR"
