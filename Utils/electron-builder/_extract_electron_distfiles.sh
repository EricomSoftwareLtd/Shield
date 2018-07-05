#!/bin/sh

docker run --rm -it --name "electron-builder" -v "${PWD}:/home/user/hostdir" "securebrowsing/electron-builder:latest" bash -c "cp -f ~/workdir/electron/dist/electron*.zip ~/hostdir/"
