#!/bin/bash -ex

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" #"
source "${DIR}/common"

function build_native() {
    rpmbuild --define="_topdir ${BUILD_DIR}" -ba "${BUILD_DIR}/SPECS/ericom_shield.spec"
}

extract_versions "${DIR}/../shield-version.txt"
recreate_dirs
create_src_archive "$SRC_DIR" "${BUILD_DIR}/SOURCES/${ERICOM_SHIELD_VERSION}.tar.gz"
prepare_spec
build_native

echo "DONE!"
