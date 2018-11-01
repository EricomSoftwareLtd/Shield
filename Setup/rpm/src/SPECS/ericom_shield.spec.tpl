Summary:   Ericom Shield for Secure Browsing
Name:      ericom_shield
Epoch:     1
Version:   ${ERICOM_SHIELD_VERSION}
Release:   1
License:   EULA
Group:     Applications/Internet
URL:       https://www.ericomshield.com/
Source0:   ${ERICOM_SHIELD_VERSION}.tar.gz

Requires: docker-ce = 18.03.1
Requires: python
Requires: python36

Conflicts: docker
Conflicts: docker-client
Conflicts: docker-client-latest
Conflicts: docker-common
Conflicts: docker-latest
Conflicts: docker-latest-logrotate
Conflicts: docker-logrotate
Conflicts: docker-selinux
Conflicts: docker-engine-selinux
Conflicts: docker-engine

%description
Ericom Shield handles browsing sessions remotely, blocking web-borne threats
from penetrating your enterprise. Isolating users from malicious web content,
Ericom Shield eliminates the browsing web threat vector while maintaining
user productivity.

%prep
tar --strip=1 -xzvf %{SOURCE0}

%install

source "Setup/rpm/src/rpm_utils.sh"

%{__rm} -rf %{buildroot}
%{__mkdir} -p %{buildroot}%{_prefix}/local/ericomshield

# %{__install} -Dp -m 755 "Setup/ericomshield-setup.sh" "%{buildroot}%{_prefix}/local/ericomshield"
# %{__install} -Dp -m 755 "Setup/update.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/autoupdate.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/start.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/showversion.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/stop.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/status.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/restart.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/show-my-ip.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/addnodes.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/nodes.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/restore.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/prepare-node.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/spellcheck.sh" "%{buildroot}%{_prefix}/local/ericomshield"
%{__install} -Dp -m 755 "Setup/shield-pre-install-check.sh" "%{buildroot}%{_prefix}/local/ericomshield"

%{__install} -Dp -m 644 "Setup/sysctl_shield.conf" "%{buildroot}%{_sysconfdir}/sysctl.d/30-ericom-shield.conf"
%{__install} -Dp -m 644 "Setup/.shield_aliases" "%{buildroot}%{_sysconfdir}/profile.d/ericom_shield.sh"

%{__install} -Dp -m 644 "Setup/docker-compose.yml" "%{buildroot}%{_prefix}/local/ericomshield/docker-compose.yml"
prepare_yml "%{buildroot}%{_prefix}/local/ericomshield/docker-compose.yml" "Setup/shield-version.txt"

%files
%dir "%{_prefix}/local/ericomshield"
%config "%{_sysconfdir}/sysctl.d/30-ericom-shield.conf"
%config "%{_sysconfdir}/profile.d/ericom_shield.sh"
%config "%{_prefix}/local/ericomshield//docker-compose.yml"
"%{_prefix}/local/ericomshield/*.sh"

%changelog
* Fri Oct 26 2018 Andrew Novikov <Andrew.Novikov@artezio.com> - 1
- Initial RPM release
