#!/bin/bash -ex

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" #"
source "${DIR}/common"

function build_in_docker() {
    local DOCKER_RPM_BUILDER_IMG="shield_rpmbuilder:latest"
    if ! docker image inspect "$DOCKER_RPM_BUILDER_IMG" >/dev/null 2>&1; then
        "${DIR}/_build_rpm_builder.sh" "$DOCKER_RPM_BUILDER_IMG"
    fi
    docker run --rm -v "${BUILD_DIR}:/home/user/work" --name "9A00342C-A532-4091-A59C-8DC445DBF9F3" "$DOCKER_RPM_BUILDER_IMG" /bin/bash -c \
        "cd /home/user/work && rpmbuild --define='_topdir /home/user/work' -ba '/home/user/work/SPECS/ericom_shield.spec'"
}

extract_versions "${DIR}/../shield-version.txt"
recreate_dirs
create_src_archive "$SRC_DIR" "${BUILD_DIR}/SOURCES/${ERICOM_SHIELD_VERSION}.tar.gz"
prepare_spec
build_in_docker

echo "DONE!"
