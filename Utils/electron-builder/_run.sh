#!/bin/sh

docker run --rm -it --name "electron-builder" -v "${PWD}:/home/user/hostdir" "securebrowsing/electron-builder:latest" bash
