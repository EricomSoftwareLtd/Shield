Summary:   Ericom Shield for Secure Browsing
Name:      ericom_shield_kube
Epoch:     0
Version:   ${ERICOM_SHIELD_VERSION}
Release:   1.%{_buildfor_rel}
License:   EULA
Group:     Applications/Internet
URL:       https://www.ericomshield.com/

Source0:   ${ERICOM_SHIELD_VERSION}.tar.gz
Source1:   %{name}-sysusers.conf
Source2:   %{name}.sudoers

BuildRequires: tar, gzip
%{?systemd_requires}
BuildRequires: systemd
BuildRequires: python36-devel

%if "%{_buildfor_rel}" == "rhel"

Requires: docker-ee >= 3:19.03.2
Requires: redhat-release-server >= 7.6

%else #"%{_buildfor_rel}" == "centos"

Requires: docker-ce >= 3:19.03.2
Requires: centos-release >= 7-6

%endif

Requires: coreutils, util-linux, iproute, grep, gawk, diffutils, jq, firewalld

# Fix Python bytecompilation
# %global __python %{__python3}

# Requires: ansible >= 2.7.1
# Requires: python-docker-py >= 1.10.6
# Requires: python-boto >= 2.25
# Requires: python-boto3 >= 1.4.6
# Requires: python36-click >= 6.7
# Requires: python36-docker-pycreds >= 0.2.1
# Requires: python36-PyYAML >= 3.11
# Requires: python36-texttable >= 1.2.1

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
%{__mkdir} -p "%{buildroot}/opt/ericomshield"
%{__mkdir} -p "%{buildroot}/opt/ericomshield/backup"
%{__mkdir} -p "%{buildroot}/opt/ericomshield/.ssh"

%{__install} -Dp -m 755 *.sh "%{buildroot}/opt/ericomshield"
%{__install} -Dp -m 644 *.yaml "%{buildroot}/opt/ericomshield"

# %{__install} -Dp -m 644 "Setup/sysctl_shield.conf" "%{buildroot}%{_sysctldir}/ericom_shield.conf"
# %{__cat} "Setup/sysctl_shield.conf" "Setup/sysctl_shield_redhat.conf" >"%{buildroot}%{_sysctldir}/ericom_shield.conf"
# %{__install} -Dp -m 644 "Setup/.shield_aliases" "%{buildroot}%{_sysconfdir}/profile.d/ericom_shield.sh"

%{__install} -Dp -m 644 "%SOURCE1" "%{buildroot}%{_sysusersdir}/%{name}.conf"

%{__install} -Dp -m 644 "%SOURCE2" "%{buildroot}%{_sysconfdir}/sudoers.d/%{name}"

%files
%dir "/opt/ericomshield"
%dir "/opt/ericomshield/backup"
%dir %attr(0755, ericom, ericom) "/opt/ericomshield/.ssh"
# %config "%{_sysctldir}/ericom_shield.conf"
# %config "%{_sysconfdir}/profile.d/ericom_shield.sh"
%config "%{_sysconfdir}/sudoers.d/%{name}"
%attr(0600, ericom, ericom) %ghost %config(missingok) "/opt/ericomshield/.ssh/authorized_keys"
%attr(0600, ericom, ericom) %ghost %config(missingok) "/opt/ericomshield/.ssh/known_hosts"
%attr(0600, ericom, ericom) %ghost %config(missingok) "/opt/ericomshield/.ssh/id_dsa"
%attr(0600, ericom, ericom) %ghost %config(missingok) "/opt/ericomshield/.ssh/id_dsa.pub"
%attr(0600, ericom, ericom) %ghost %config(missingok) "/opt/ericomshield/.ssh/id_rsa"
%attr(0600, ericom, ericom) %ghost %config(missingok) "/opt/ericomshield/.ssh/id_rsa.pub"
"/opt/ericomshield/*.sh"
"/opt/ericomshield/*.yaml"
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
systemctl enable docker.service >/dev/null 2>&1 || :

%sysctl_apply "%{_sysctldir}/ericom_shield.conf"

TZ="$(date '+%Z')"
ES_YML_FILE="/opt/ericomshield/docker-compose.yml"
%{__sed} -i'' "s#TZ=UTC#TZ=${TZ}#g" "${ES_YML_FILE}"

if ! [ -z ${ericom_shield_authorized_keys+x} ]; then echo "$ericom_shield_authorized_keys" >"/opt/ericomshield/.ssh/authorized_keys"; fi
if ! [ -z ${ericom_shield_known_hosts+x} ]; then echo "$ericom_shield_known_hosts" >"/opt/ericomshield/.ssh/known_hosts"; fi
if ! [ -z ${ericom_shield_id_dsa+x} ]; then echo "$ericom_shield_id_dsa" >"/opt/ericomshield/.ssh/id_dsa"; fi
if ! [ -z ${ericom_shield_id_dsa_pub+x} ]; then echo "$ericom_shield_id_dsa_pub" >"/opt/ericomshield/.ssh/id_dsa.pub"; fi
if ! [ -z ${ericom_shield_id_rsa+x} ]; then echo "$ericom_shield_id_rsa" >"/opt/ericomshield/.ssh/id_rsa"; fi
if ! [ -z ${ericom_shield_id_rsa_pub+x} ]; then echo "$ericom_shield_id_rsa_pub" >"/opt/ericomshield/.ssh/id_rsa.pub"; fi

systemctl start firewalld >/dev/null 2>&1 || :
firewall-cmd --add-port=2376/tcp --permanent >/dev/null 2>&1 || :
firewall-cmd --add-port=2377/tcp --permanent >/dev/null 2>&1 || :
firewall-cmd --add-port=7946/tcp --permanent >/dev/null 2>&1 || :
firewall-cmd --add-port=7946/udp --permanent >/dev/null 2>&1 || :
firewall-cmd --add-port=4789/udp --permanent >/dev/null 2>&1 || :
firewall-cmd --reload >/dev/null 2>&1 || :

%preun

%postun

%changelog
* Fri Oct 26 2018 Andrew N. - 1
- Initial RPM release
