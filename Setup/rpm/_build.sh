#!/bin/bash -ex

export ERICOM_SHIELD_VERSION="Dev"
export DOCKER_VERSION_LOW="18.03.1"
export DOCKER_VERSION_HIGH="18.03.2"

SUBST_VARIABLES='$ERICOM_SHIELD_VERSION $DOCKER_VERSION_LOW $DOCKER_VERSION_HIGH'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #"
#source "${DIR}/common"

# export ES_EULA_BASE64="$(base64 -w0 "${DIR}/../Ericom-EULA.txt")"

BUILD_DIR="${DIR}/_build/rpm"

if [ -d "${BUILD_DIR}" ] ; then
    rm -rf "${BUILD_DIR}"
fi
mkdir -p "${BUILD_DIR}"

cp -r "${DIR}/src"/* "${DIR}/_build/rpm"

#curl -L "https://api.github.com/repos/EricomSoftwareLtd/Shield/tarball/${ERICOM_SHIELD_VERSION}" >"${BUILD_DIR}/SOURCES/${ERICOM_SHIELD_VERSION}.tar.gz"
(cd ../../.. && tar czvf "/tmp/${ERICOM_SHIELD_VERSION}.tar.gz" Shield && mv "/tmp/${ERICOM_SHIELD_VERSION}.tar.gz" "${BUILD_DIR}/SOURCES/${ERICOM_SHIELD_VERSION}.tar.gz")
envsubst <"${BUILD_DIR}/SPECS/ericom_shield.spec.tpl" "$SUBST_VARIABLES" >"${BUILD_DIR}/SPECS/ericom_shield.spec"

rpmbuild \
 --define="_topdir ${BUILD_DIR}" \
 -ba "${BUILD_DIR}/SPECS/ericom_shield.spec"

#find "${BUILD_DIR}/RPMS" -type f -name "*.rpm" -exec mv "{}" "${DIR}/_build" \;

#rm -rf "${BUILD_DIR}"

echo "DONE!"
