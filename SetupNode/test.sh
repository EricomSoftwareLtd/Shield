#!/bin/bash -x


VER=$(python --version)
echo "$VER"
python scripts/make_env.py "${@}"