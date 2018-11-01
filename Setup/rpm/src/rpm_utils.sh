#!/bin/sh

prepare_yml() {
    local ES_YML_FILE="$1"
    local ES_VER_FILE="$2"
    while read -r ver; do
        if [ "${ver:0:1}" == '#' ]; then
            echo "$ver"
        else
            pattern_ver="$(echo "$ver" | awk '{print $1}')"
            comp_ver="$(echo "$ver" | awk '{print $2}')"
            if [ ! -z "$pattern_ver" ]; then
                #echo "Changing ver: $comp_ver"
                sed -i'' "s/$pattern_ver/$comp_ver/g" "$ES_YML_FILE"
            fi
        fi
    done <"$ES_VER_FILE"
}
