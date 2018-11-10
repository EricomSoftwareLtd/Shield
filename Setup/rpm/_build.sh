#!/bin/bash -ex

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" #"
#source "${DIR}/common"

BUILD_DIR="${DIR}/_build/rpm"
SRC_DIR="${DIR}/../.."

if [ -d "${BUILD_DIR}" ]; then
    rm -rf "${BUILD_DIR}"
fi
mkdir -p "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}/SPECS"
mkdir -p "${BUILD_DIR}/SOURCES"

function extract_versions() {
    local VER_FILE="$1"
    local VER_REGEX='^SHIELD_VER=[a-zA-Z.0-9]+[[:blank:]]+SHIELD_VER=([a-zA-Z]+):Build_([0-9]+)$'
    local DOCKER_VER_REGEX='^#{0,1}docker-version[[:blank:]]+(([[:digit:]]+\.)+)([[:digit:]]+)[[:blank:]]*$'
    while read -r line; do
        if [[ $line =~ $VER_REGEX ]]; then
            local REL="$(echo "${BASH_REMATCH[1]}" | tr A-Z a-z)"
            local REL="${BASH_REMATCH[1]}"
            export ERICOM_SHIELD_VERSION="${REL}.${BASH_REMATCH[2]}"
        elif [[ $line =~ $DOCKER_VER_REGEX ]]; then
            local n=${#BASH_REMATCH[*]}
            export DOCKER_VERSION_LOW="${BASH_REMATCH[1]}${BASH_REMATCH[n - 1]}"
            export DOCKER_VERSION_HIGH="${BASH_REMATCH[1]}$((BASH_REMATCH[n - 1] + 1))"
        fi
    done <"$VER_FILE"
}

extract_versions "${DIR}/../shield-version.txt"

function create_src_archive() {
    local SRC="$1"
    local TB="$2"
    (cd "${SRC}" && git ls-files | tar czvT -) >"$TB"
    #curl -L "https://api.github.com/repos/EricomSoftwareLtd/Shield/tarball/${ERICOM_SHIELD_VERSION}" >"${BUILD_DIR}/SOURCES/${ERICOM_SHIELD_VERSION}.tar.gz"
}

create_src_archive "$SRC_DIR" "${BUILD_DIR}/SOURCES/${ERICOM_SHIELD_VERSION}.tar.gz"

SUBST_VARIABLES='$ERICOM_SHIELD_VERSION $DOCKER_VERSION_LOW $DOCKER_VERSION_HIGH'
envsubst <"${DIR}/ericom_shield.spec.tpl" "$SUBST_VARIABLES" >"${BUILD_DIR}/SPECS/ericom_shield.spec"

rpmbuild \
    --define="_topdir ${BUILD_DIR}" \
    -ba "${BUILD_DIR}/SPECS/ericom_shield.spec"

#find "${BUILD_DIR}/RPMS" -type f -name "*.rpm" -exec mv "{}" "${DIR}/_build" \;

#rm -rf "${BUILD_DIR}"

echo "DONE!"
