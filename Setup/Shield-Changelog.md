# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).
- Git Issues should be referenced by #
- Main Features/Bug Fixes should have (*)
- User Action Required should have (!)

## [Unreleased]

## [17.41-Build:183] - 2017-10-22
### New Features:
- New Module: Web Service 
  -  - Allows to download the certificate from: http:<SHIELD_SERVER>:8888/install-certificate or directly from: http://<SHIELD_SERVER>:8888/ericomshield.crt
  -  - Allows to download the auto-generated PAC file from: http:<SHIELD_SERVER>:8888/default.pac
  -  - PAC File can be uploaded (currently on Consul: http://<SHIELD_SERVER:8181/ui/#/dc1/kv/settings/pacfile/edit )
- Japanese Keyboard (basic) Support
- New Module: shield-maintenance (Cleans old images and used Remot Browsers)
### Tech Preview:
- Basic support for Proxy Authentication (User Name/Password for Proxy)
- Basic support for Internet Explorer Mode #819
  -  - Settings in Consul:
  -  - http://<SHIELD_SERVER:8181/ui/#/dc1/kv/settings/icap/edit
  -  - "as_address":"ACCESS_SERVER_IP","as_port":"8080","as_username":"ccadmin@cloudconnect.local","as_password":"XXXXXX"
  -  - http://<SHIELD_SERVER>:8181/ui/#/dc1/kv/policies/policies/edit in Consul
  -  - Replace Action for an existing Policy with access = 3
### Enhancements:
- Use settings from host's /etc/resolv.conf for DNS resolver in proxy-server
- Added EULA during installation #874
- Installing Docker Version 17.06 (Upgrade/Downgrade if version is different)
- Dashboard refresh for every 5 seconds #787 

### Fixed:
- Fixed SystemId bug #888
- Fixed Documnation link #885
- Adding Flag to Restart the system during upgrade when required
- **(*) Support non-english file name download  #710 **
- **(*) Added web service component to provide certificate and PAC file #782**


## [17.37-Build:172] - 2017-09-14
- (*) New Logic for Apps based on User Agent #667 - (!) please clear automatic rules on upgrade 
- File Sanitizaiton (Votiro Integration)
- (*) Automatic Rules Addition disabled
- Soak Tests (4h, more than 4000 URLs)
- (*) Protect Kibana and Portainer UIs with password (#706)
