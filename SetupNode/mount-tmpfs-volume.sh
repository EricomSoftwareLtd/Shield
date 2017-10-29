#!/bin/bash


if [ ! -d "/media/containershm" ]; then
    mkdir -p /media/containershm
    mount -t tmpfs -o size=2G tmpfs /media/containershm
    echo 'tmpfs   /media/containershm     tmpfs   rw,size=2G      0       0' >> /etc/fstab
fi