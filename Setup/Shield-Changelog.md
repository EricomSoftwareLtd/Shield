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
- User Authentication:
  - Basic Authentication (User Name/Password)
  - LDAP
  - Kerberos
  - NTLM (fallback)
- User Profile 
- Multi-Node Support (Scalability and High Availability) #911 
    - Prepare Node with Ubuntu, Run PrepareNode script on it
    - Run sudo ./ericomshield-setup-node.sh -ips xxx.xx.xx.xx,yy.yy.yy.yy -mng -b -sc
    - https://github.com/EricomSoftwareLtd/Shield/blob/master/README.md
- Internet Explorer Mode
- File Sanitization (CDR Votiro) settings in Admin UI
- File Sanitization (CDR): Password Protected files support
- Admin UI: Added "comment" field to policies. (removed "auto" column) #887
- PAC File: Download and Upload from the admin
- File Upload Support #350

- New Module: Web Service 
    - Allows to download the certificate from: http:<SHIELD_SERVER>/install-certificate or directly from: http://<SHIELD_SERVER>/ericomshield.crt
    - Allows to download the auto-generated PAC file from: http:<SHIELD_SERVER>/default.pac
- Japanese Keyboard Support
- New Module: shield-maintenance 
    - Cleans old docker images and used Remote Browsers

### Enhancements:
- Backup / Resore verify that the settings are ok before creating a backup
- Propagate Client IP, XFF (X-Forward-For)  to external proxies #1078
- Use settings from host's /etc/resolv.conf for DNS resolver in proxy-server
- Dashboard refresh for every 5 seconds #787 
- Adding Flag to Restart the system during upgrade when required

### Fixed:
- Bug fix when zoom #960 #961
- Fixed SystemID bug #888
- Fixed Documentation link #885
- Various Bug fixes on File Sanitization (CDR) (#1077 #1084 #1076 #1081 #1083)
- Support non-English file name download #710 
- And dozens of other fixes...

## [17.09-Build:172] - 2017-09-14
- (*) New Logic for Apps based on User Agent #667 - (!) please clear automatic rules on upgrade 
- File Sanitization (Votiro Integration)
- (*) Automatic Rules Addition disabled
- Soak Tests (4h, more than 4000 URLs)
- (*) Protect Kibana and Portainer UIs with password (#706)

