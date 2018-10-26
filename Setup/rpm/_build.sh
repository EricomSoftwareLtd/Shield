#!/bin/bash -ex

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #"
#source "${DIR}/common"

export ERICOM_SHIELD_VERSION="Dev"
export DIR

BUILD_DIR="${DIR}/_build/rpm"

if [ -d "${BUILD_DIR}" ] ; then
    rm -rf "${BUILD_DIR}"
fi
mkdir -p "${BUILD_DIR}"

cp -r "${DIR}/src"/* "${DIR}/_build/rpm"

curl -L "https://api.github.com/repos/EricomSoftwareLtd/Shield/tarball/${ERICOM_SHIELD_VERSION}" >"${BUILD_DIR}/SOURCES/${ERICOM_SHIELD_VERSION}.tar.gz"
envsubst <"${BUILD_DIR}/SPECS/ericom_shield.spec.tpl" >"${BUILD_DIR}/SPECS/ericom_shield.spec"

rpmbuild \
 --define="_topdir ${BUILD_DIR}" \
 -ba "${BUILD_DIR}/SPECS/ericom_shield.spec"

#find "${BUILD_DIR}/RPMS" -type f -name "*.rpm" -exec mv "{}" "${DIR}/_build" \;

#rm -rf "${BUILD_DIR}"

echo "DONE!"
