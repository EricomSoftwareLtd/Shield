#!/bin/bash -ex

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" #"
source "${DIR}/common"

function build_in_docker() {
    if ! docker image inspect "$DOCKER_RPM_BUILDER_IMG_TAG" >/dev/null 2>&1; then
        "${DIR}/_build_rpm_builder.sh" "$DOCKER_RPM_BUILDER_IMG_TAG"
    fi
    local DOCKER_OPTS=(--rm -w="/home/user/work" -v "${BUILD_DIR}:/home/user/work" --name "9A00342C-A532-4091-A59C-8DC445DBF9F3" "$DOCKER_RPM_BUILDER_IMG_TAG")
    docker run "${DOCKER_OPTS[@]}" /bin/bash -c "chown -R user:user '/home/user/work'"
    docker run --user="user:user" "${DOCKER_OPTS[@]}" /bin/bash -c "rpmbuild --define='_topdir /home/user/work' --define '_buildfor_rel rhel' -ba '/home/user/work/SPECS/ericom_shield.spec'"
    docker run --user="user:user" "${DOCKER_OPTS[@]}" /bin/bash -c "rpmbuild --define='_topdir /home/user/work' --define '_buildfor_rel centos' -ba '/home/user/work/SPECS/ericom_shield.spec'"
    docker run "${DOCKER_OPTS[@]}" /bin/bash -c "chown -R $(id -u):$(id -g) /home/user/work"
    cp "${BUILD_DIR}/RPMS/x86_64/ericom_shield-"*".rhel.x86_64.rpm" "${BUILD_DIR}/RPMS/x86_64/ericom_shield.rhel.x86_64.rpm"
    cp "${BUILD_DIR}/RPMS/x86_64/ericom_shield-"*".centos.x86_64.rpm" "${BUILD_DIR}/RPMS/x86_64/ericom_shield.centos.x86_64.rpm"
}

extract_versions "${DIR}/../shield-version.txt"
recreate_dirs
create_src_archive "$SRC_DIR" "${BUILD_DIR}/SOURCES/${ERICOM_SHIELD_VERSION}.tar.gz"
prepare_spec
build_in_docker

echo "DONE!"
