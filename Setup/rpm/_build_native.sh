#!/bin/bash -ex

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" #"
source "${DIR}/common"

function build_native() {
    rpmbuild --define="_topdir ${BUILD_DIR}" --define '_buildfor_rel rhel' -ba "${BUILD_DIR}/SPECS/ericom_shield.spec"
    rpmbuild --define="_topdir ${BUILD_DIR}" --define '_buildfor_rel centos' -ba "${BUILD_DIR}/SPECS/ericom_shield.spec"
    cp "${BUILD_DIR}/RPMS/x86_64/ericom_shield-"*".rhel.x86_64.rpm" "${BUILD_DIR}/RPMS/x86_64/ericom_shield.rhel.x86_64.rpm"
    cp "${BUILD_DIR}/RPMS/x86_64/ericom_shield-"*".centos.x86_64.rpm" "${BUILD_DIR}/RPMS/x86_64/ericom_shield.centos.x86_64.rpm"
}

extract_versions "${DIR}/../shield-version.txt"
recreate_dirs
create_src_archive "$SRC_DIR" "${BUILD_DIR}/SOURCES/${ERICOM_SHIELD_VERSION}.tar.gz"
prepare_spec
build_native

echo "DONE!"
