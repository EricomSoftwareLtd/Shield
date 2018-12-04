Summary:   Ericom Shield for Secure Browsing
Name:      ericom_shield
Epoch:     0
Version:   ${ERICOM_SHIELD_VERSION}
Release:   1
License:   EULA
Group:     Applications/Internet
URL:       https://www.ericomshield.com/

Source0:   ${ERICOM_SHIELD_VERSION}.tar.gz
Source1:   %{name}-sysusers.conf
Source2:   %{name}.sudoers

BuildRequires: tar, gzip
%{?systemd_requires}
BuildRequires: systemd

Requires: docker-ce >= ${DOCKER_VERSION_LOW}, docker-ce < ${DOCKER_VERSION_HIGH}
Requires: coreutils, util-linux, iproute, grep, gawk, diffutils, jq
Requires: centos-release >= 7-5

Requires: ansible >= 2.7.1, ansible < 2.8
Requires: python-boto >= 2.25
Requires: python-boto3 >= 1.4.6
Requires: python34-click >= 6.7
Requires: python-docker-py >= 1.10.6
Requires: python34-docker-pycreds >= 0.2.1
Requires: python34-PyYAML >= 3.11
Requires: python34-texttable >= 1.2.1

Requires(pre): /usr/sbin/useradd, /usr/sbin/usermod, /usr/bin/getent, /usr/bin/which
Requires(postun): /usr/sbin/userdel

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
# %{__tar} --strip=1 -xzvf %{SOURCE0}
%{__tar} -xzvf %{SOURCE0}

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
%{__mkdir} -p "%{buildroot}%{_prefix}/local/ericomshield"
%{__mkdir} -p "%{buildroot}%{_prefix}/local/ericomshield/backup"
%{__mkdir} -p "%{buildroot}%{_prefix}/local/ericomshield/.ssh"

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

%{__install} -Dp -m 644 "Setup/sysctl_shield.conf" "%{buildroot}%{_sysctldir}/ericom_shield.conf"
%{__install} -Dp -m 644 "Setup/.shield_aliases" "%{buildroot}%{_sysconfdir}/profile.d/ericom_shield.sh"

%{__install} -Dp -m 644 "Setup/docker-compose.yml" "%{buildroot}%{_prefix}/local/ericomshield/docker-compose.yml"
prepare_yml "%{buildroot}%{_prefix}/local/ericomshield/docker-compose.yml" "Setup/shield-version.txt"

%{__install} -Dp -m 644 "Setup/shield-version.txt" "%{buildroot}%{_prefix}/local/ericomshield"

%{__install} -Dp -m 644 "Setup/Ericom-EULA.txt" "%{buildroot}%{_prefix}/local/ericomshield"

%{__install} -Dp -m 644 "Setup/media-containershm.mount" "%{buildroot}%{_unitdir}/media-containershm.mount"
%{__install} -Dp -m 644 "%SOURCE1" "%{buildroot}%{_sysusersdir}/%{name}.conf"

%{__install} -Dp -m 644 "%SOURCE2" "%{buildroot}%{_sysconfdir}/sudoers.d/%{name}"

%files
%dir "%{_prefix}/local/ericomshield"
%dir "%{_prefix}/local/ericomshield/backup"
%dir %attr(0755, ericom, ericom) "%{_prefix}/local/ericomshield/.ssh"
%config "%{_sysctldir}/ericom_shield.conf"
%config "%{_sysconfdir}/profile.d/ericom_shield.sh"
%config "%{_sysconfdir}/sudoers.d/%{name}"
%config "%{_prefix}/local/ericomshield/docker-compose.yml"
%config "%{_prefix}/local/ericomshield/shield-version.txt"
%ghost %config(missingok) "%{_prefix}/local/ericomshield/.es_ip_address"
%attr(0600, ericom, ericom) %ghost %config(missingok) "%{_prefix}/local/ericomshield/.ssh/authorized_keys"
%attr(0600, ericom, ericom) %ghost %config(missingok) "%{_prefix}/local/ericomshield/.ssh/known_hosts"
%attr(0600, ericom, ericom) %ghost %config(missingok) "%{_prefix}/local/ericomshield/.ssh/id_dsa"
%attr(0600, ericom, ericom) %ghost %config(missingok) "%{_prefix}/local/ericomshield/.ssh/id_dsa.pub"
%attr(0600, ericom, ericom) %ghost %config(missingok) "%{_prefix}/local/ericomshield/.ssh/id_rsa"
%attr(0600, ericom, ericom) %ghost %config(missingok) "%{_prefix}/local/ericomshield/.ssh/id_rsa.pub"
%doc "%{_prefix}/local/ericomshield/Ericom-EULA.txt"
%ghost "%{_prefix}/local/ericomshield/.eula_accepted"
%ghost "%{_prefix}/local/ericomshield/ericomshield.log"
"%{_prefix}/local/ericomshield/*.sh"
"%{_prefix}/local/ericomshield/*.py"
"%{_prefix}/local/ericomshield/*.pyc"
"%{_prefix}/local/ericomshield/*.pyo"
"%{_unitdir}/media-containershm.mount"
"%{_sysusersdir}/%{name}.conf"

%pre -p /bin/bash
function add_sysusers() {
    local COMMENT_REGEX='^#.*$'
    local U_REGEX='^u[[:blank:]]+([a-zA-Z0-9]+)[[:blank:]]+(-|[0-9]+)[[:blank:]]+"(.*?[^\\])"[[:blank:]]+([-_\/a-zA-Z0-9]+)[[:blank:]]+([-_\/a-zA-Z0-9]+)$'
    local M_REGEX='^m[[:blank:]]+([a-zA-Z0-9]+)[[:blank:]]+([a-zA-Z0-9]+)$'
    while read -r line; do
        if [[ $line =~ $U_REGEX ]]; then
            if [[ ${BASH_REMATCH[2]} != "-" ]]; then
                local UID_O=--uid "${BASH_REMATCH[2]}"
            fi
            /usr/bin/getent passwd ${BASH_REMATCH[1]} >/dev/null || /usr/sbin/useradd --system --no-create-home $UID_O --comment "${BASH_REMATCH[3]}" --home-dir "${BASH_REMATCH[4]}" --shell "${BASH_REMATCH[5]}" ${BASH_REMATCH[1]}
        elif [[ $line =~ $M_REGEX ]]; then
            /usr/sbin/usermod --append --groups ${BASH_REMATCH[2]} ${BASH_REMATCH[1]}
        elif [[ $line =~ $COMMENT_REGEX ]]; then
            continue
        else
            echo "Unexpected line '$line'"
            exit 1
        fi
    done <<SYSTEMD_INLINE_EOF
%(cat %SOURCE1)
SYSTEMD_INLINE_EOF
}

if /usr/bin/which systemd-sysusers >/dev/null 2>&1; then
systemd-sysusers --replace="%{_sysusersdir}/%{name}.conf" - <<SYSTEMD_INLINE_EOF &>/dev/null || :
%(cat %SOURCE1)
SYSTEMD_INLINE_EOF
else
add_sysusers
fi


%post -p /bin/bash
%systemd_post media-containershm.mount
systemctl enable media-containershm.mount >/dev/null 2>&1 || :
systemctl start media-containershm.mount >/dev/null 2>&1 || :

%sysctl_apply "%{_sysctldir}/ericom_shield.conf"

TZ="$(date '+%Z')"
ES_YML_FILE="%{_prefix}/local/ericomshield/docker-compose.yml"
%{__sed} -i'' "s#TZ=UTC#TZ=${TZ}#g" "${ES_YML_FILE}"

if ! [ -z ${ericom_shield_authorized_keys+x} ]; then echo "$ericom_shield_authorized_keys" >"%{_prefix}/local/ericomshield/.ssh/authorized_keys"; fi
if ! [ -z ${ericom_shield_known_hosts+x} ]; then echo "$ericom_shield_known_hosts" >"%{_prefix}/local/ericomshield/.ssh/known_hosts"; fi
if ! [ -z ${ericom_shield_id_dsa+x} ]; then echo "$ericom_shield_id_dsa" >"%{_prefix}/local/ericomshield/.ssh/id_dsa"; fi
if ! [ -z ${ericom_shield_id_dsa_pub+x} ]; then echo "$ericom_shield_id_dsa_pub" >"%{_prefix}/local/ericomshield/.ssh/id_dsa.pub"; fi
if ! [ -z ${ericom_shield_id_rsa+x} ]; then echo "$ericom_shield_id_rsa" >"%{_prefix}/local/ericomshield/.ssh/id_rsa"; fi
if ! [ -z ${ericom_shield_id_rsa_pub+x} ]; then echo "$ericom_shield_id_rsa_pub" >"%{_prefix}/local/ericomshield/.ssh/id_rsa.pub"; fi

%preun
%systemd_preun media-containershm.mount

%postun
%systemd_postun media-containershm.mount

%changelog
* Fri Oct 26 2018 Andrew Novikov <Andrew.Novikov@artezio.com> - 1
- Initial RPM release
