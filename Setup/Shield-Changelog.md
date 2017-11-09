# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).
- Git Issues should be referenced by #
- Main Features/Bug Fixes should have (*)
- User Action Required should have (!)

## [Unreleased]

## [Staging:17.11] - 2017-11-6

### New Features:
- User Profile
- User Authentication:
  - Basic Authentication (User Name/Passowrd)
  - Kerberos
  - LDAP
  - NTLM (fallback)
- Multi-node (Scalability and High Availability) Support #911
- File Sanitization (CDR Votiro) settings in Admin UI
- File Sanitization (CDR) password protected files support
- AdminUI: Added comment property to policies. removed auto column #887
- PAC File Upload
- File Upload Support #350
- Internet Explorer Mode
- New Module: Web Service 
    - Allows to download the certificate from: http:<SHIELD_SERVER>/install-certificate or directly from: http://<SHIELD_SERVER>/ericomshield.crt
    - Allows to download the auto-generated PAC file from: http:<SHIELD_SERVER>:8888/default.pac
    - PAC File can be uploaded (currently on Consul: http://<SHIELD_SERVER:8181/ui/#/dc1/kv/settings/pacfile/edit )
- Japanese Keyboard Support
- New Module: shield-maintenance (Cleans old images and used Remot Browsers)
- Multi-Node Support:
    - Prepare Node with Ubuntu, Run PrepareNode script on it
    - Run sudo ./ericomshield-setup-node.sh -ips xxx.xx.xx.xx,yy.yy.yy.yy -mng -b -sc
    - https://github.com/EricomSoftwareLtd/Shield/blob/master/README.md

### Enhancements:
- Use settings from host's /etc/resolv.conf for DNS resolver in proxy-server
- Added EULA during installation #874
- Installing Docker Version 17.06 (Upgrade/Downgrade if version is different)
- Dashboard refresh for every 5 seconds #787 
- Adding Flag to Restart the system during upgrade when required
- Autoupdate is not set by default, run the install with -autoupdate to enable it
- If Multi-Network Cards are detected during the install, the user is asked to select the IP to use

### Fixed:
- Bug fix when zoom #960 #961
- Fixed SystemId bug #888
- Fixed Documentation link #885
- Various Bug fixes on File Sanitization (CDR) (#1077 #1084 #1076 #1081 #1083)
- Support non-english file name download  #710

## [17.09-Build:172] - 2017-09-14
- (*) New Logic for Apps based on User Agent #667 - (!) please clear automatic rules on upgrade 
- File Sanitizaiton (Votiro Integration)
- (*) Automatic Rules Addition disabled
- Soak Tests (4h, more than 4000 URLs)
- (*) Protect Kibana and Portainer UIs with password (#706)
