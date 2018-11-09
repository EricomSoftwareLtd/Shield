Summary:   Ericom Shield for Secure Browsing
Name:      ericom_shield
Epoch:     1
Version:   ${ERICOM_SHIELD_VERSION}
Release:   1
License:   EULA
Group:     Applications/Internet
URL:       https://www.ericomshield.com/
Source0:   ${ERICOM_SHIELD_VERSION}.tar.gz

BuildRequires: tar, gzip
%{?systemd_requires}
BuildRequires: systemd

Requires: docker-ce >= ${DOCKER_VERSION_LOW}, docker-ce < ${DOCKER_VERSION_HIGH}
Requires: coreutils, util-linux, iproute, grep, gawk, diffutils, jq
Requires: centos-release >= 7-5

Conflicts: docker
Conflicts: docker-client
Conflicts: docker-client-latest
Conflicts: docker-common
Conflicts: docker-latest
Conflicts: docker-latest-logrotate
Conflicts: docker-logrotate
Conflicts: docker-engine
Conflicts: bind, dnsmasq, unbound

%description
Ericom Shield handles browsing sessions remotely, blocking web-borne threats
from penetrating your enterprise. Isolating users from malicious web content,
Ericom Shield eliminates the browsing web threat vector while maintaining
user productivity.

%prep
tar --strip=1 -xzvf %{SOURCE0}

%install

prepare_yml() {
    local ES_YML_FILE="$1"
    local ES_VER_FILE="$2"
    while read -r ver; do
        if [ "${ver:0:1}" == '#' ]; then
            echo "$ver"
        else
            pattern_ver="$(echo "$ver" | %{__awk} '{print $1}')"
            comp_ver="$(echo "$ver" | %{__awk} '{print $2}')"
            if [ ! -z "$pattern_ver" ]; then
                #echo "Changing ver: $comp_ver"
                %{__sed} -i'' "s/$pattern_ver/$comp_ver/g" "$ES_YML_FILE"
            fi
        fi
    done <"$ES_VER_FILE"
}

%{__rm} -rf %{buildroot}
%{__mkdir} -p %{buildroot}%{_prefix}/local/ericomshield
%{__mkdir} -p %{buildroot}%{_prefix}/local/ericomshield/backup

# %{__install} -Dp -m 755 "Setup/ericomshield-setup.sh" "%{buildroot}%{_prefix}/local/ericomshield"
# %{__install} -Dp -m 755 "Setup/update.sh" "%{buildroot}%{_prefix}/local/ericomshield"
# %{__install} -Dp -m 755 "Setup/prepare-node.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/autoupdate.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/start.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/deploy-shield.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/showversion.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/stop.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/status.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/restart.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/show-my-ip.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/addnodes.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/addnodes.py" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/nodes.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/restore.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/spellcheck.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/shield-pre-install-check.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/rpm-setup.sh" "%{buildroot}%{_prefix}/local/ericomshield/setup.sh"

%{__install} -Dp -m 644 "Setup/sysctl_shield.conf" "%{buildroot}%{_sysconfdir}/sysctl.d/30-ericom-shield.conf"
%{__install} -Dp -m 644 "Setup/.shield_aliases" "%{buildroot}%{_sysconfdir}/profile.d/ericom_shield.sh"

%{__install} -Dp -m 644 "Setup/docker-compose.yml" "%{buildroot}%{_prefix}/local/ericomshield/docker-compose.yml"
prepare_yml "%{buildroot}%{_prefix}/local/ericomshield/docker-compose.yml" "Setup/shield-version.txt"

%{__install} -Dp -m 644 "Setup/shield-version.txt" "%{buildroot}%{_prefix}/local/ericomshield"

%{__install} -Dp -m 644 "Setup/Ericom-EULA.txt" "%{buildroot}%{_prefix}/local/ericomshield"

%files
%dir "%{_prefix}/local/ericomshield"
%dir "%{_prefix}/local/ericomshield/backup"
%config "%{_sysconfdir}/sysctl.d/30-ericom-shield.conf"
%config "%{_sysconfdir}/profile.d/ericom_shield.sh"
%config "%{_prefix}/local/ericomshield/docker-compose.yml"
%config "%{_prefix}/local/ericomshield/shield-version.txt"
%ghost %config(missingok) "%{_prefix}/local/ericomshield/.es_ip_address"
%doc "%{_prefix}/local/ericomshield/Ericom-EULA.txt"
%ghost "%{_prefix}/local/ericomshield/.eula_accepted"
%ghost "%{_prefix}/local/ericomshield/ericomshield.log"
"%{_prefix}/local/ericomshield/*.sh"
"%{_prefix}/local/ericomshield/*.py"
"%{_prefix}/local/ericomshield/*.pyc"
"%{_prefix}/local/ericomshield/*.pyo"

%pre

%post
TZ="$(date '+%Z')"
ES_YML_FILE="%{_prefix}/local/ericomshield/docker-compose.yml"
%{__sed} -i'' "s#TZ=UTC#TZ=${TZ}#g" "${ES_YML_FILE}"

%changelog
* Fri Oct 26 2018 Andrew Novikov <Andrew.Novikov@artezio.com> - 1
- Initial RPM release
