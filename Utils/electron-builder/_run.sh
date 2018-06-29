#!/bin/sh

docker run --rm -it --name "electron-builder" -v "/home/ericom/projects/Shield/Utils/electron-builder/workdir:/home/user/workdir" "securebrowsing/electron-builder:latest" bash
