# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).
- Git Issues should be referenced by #
- Main Features/Bug Fixes should have (*)
- User Action Required should have (!)

## [Unreleased]

## [Prod:18.02-1-Build-280.1] - 2018-02-18
### Enhancements:
- Pre-check Installer Shield #2068
- Pre-install check ubuntu and kernel version 
- Added alert when system requires activation
- Implement Keepalive with Votiro Server
- Blacklist Policy rows should be also strikethrough
- Publishing dynamic PAC files

### Bug Fixes:
- Duplicate Policies when using profiles (identified as a cookies issue)
- Downloads of direct links do not work : "Download Disabled" message
- Open new tab? notification is displayed when open link with middle click
- Cross windows -booking.com
- Emirates.com - Can't click on the website

- Remote Browsers are not starting after reboot
- Activation: Key already in use
- Admin takes long to load when no internet
- The leader node IP displayed is 0.0.0.0
- Prevent NTLM from crashing when wrong DC address
- Admin - policies - default values are taken from the current profile in focus
- Backup service is not running on the leader and user need to restore the data
- Admin Dashboard with long urls
- Open new tab? notification is displayed when open link with middle click


## [Prod:18.02-Build-275] - 2018-02-04
### New Features:
#### End User Features:
-	Improved Cookies support (performance)
-	Improved performance 
    -	Caching feature (configurable in the Admin)
    -	New PAC file (no DNS)
-	Improved Scrolling (lowering quality during scroll)
-	Zoom with ctrl+mouse
-	Cross Windows Issues fix
- Added more User-Agent for Applications detection (e.g. Dropbox)
- Korean Support
#### Administrator Features:
-	Support Large Deployments (thousands of LDAP groups and users)
- Cookies are disabled by default for improved Performance and Security
- Min Available Browsers auto-calculated (minimum 20)
-	AdminUI:
    -	Background Tab Timeout (Suspend) can be defined in policy (per Domain/per User Profile)
    -	Added Alerts infrastructure, and 5 indicators to the Admin UI
    -	Added data collection for : totalDiskMB, diskUsage, networkRxBytesPerSec, networkTxBytesPerSec, upTime
    -	Added alert for Active Directory binding failure
    -	Added disk capacity and usage (data collection and display in the Admin UI)
    -	Browsers farm overloaded alerts per resource (memory, cpu, disk)
    -	Implement Keepalive with Votiro Server
    -	Set background colors for nodes table values based on alerts thresholds.
    -	White mode indicator inside admin policy table. (details)
-	Backup/Restore Configuration feature
-	Full support for Upstream proxy
-	Support Upstream proxy client certificate + trusting customer CA certificate (Admin side)
-	New Docker Version 17.12
-	New Version of CDR (Votiro 7.2.1)
- NetData Customized to show only relevant data
- Ext-Proxy Improvements (High-availability, Caching, DNS Support)
### Bug Fixes:
-	Fix Right-Click on hovered links
-	Wrong link to download dropbox #1803
-	ericom.com is in white mode when using IE 11 
-	Blank screen from Oktopost #1806 - set language in browser
-	CTRL+Click on a link should open in new tab #1581
- Scroll up/down is not working with shield for some url #1269
-	Pressing Shift+click should open a new window #1269
-	Support "Find in page" CTRL+F #354
-	Administrator:
    -	Admin UI sometimes doesn't display data - when admin show no data #1725
    -	CTRL+Click on a link should open in new tab #1581
    -	Default timeout waiting for sanitization is now 10 minutes (was 5 ) #1660
    - Multi-Machine Deployments bug fixes
    - Caching logic improved
    - No Error for Black list URLs fix

## [Prod:18.01-Build-249.5] - 2018-01-07
### New Features:
- Pre-installation checks are performed before installation.
- Background tabs are handled with dedicated timeouts (for edit and for read-write tabs) and become dormant when these timeouts are met. This is done to reduce hardware usage and improve resources management.
- Resource computation - CPU and memory usage is constantly monitored and displayed in the dashboard. Number of available standby remote browsers is defined by this information.
- Upstream Proxy - when an upstream proxy is used, Ericom Shield will use it to connect to the internet.
- Dashboard now includes more details about the system, including CPU and memory, total and average. Nodes table was also updated to include more data.
- Links and pop ups are opened seamlessly, except for certain cases where this is technically problematic - then a relevant message is issued to the user, to allow pop-ups per the specific site.
- Added support for Zoom in Browser and DPI Settings. Zoom can be changed using keyboard, mouse & browser.
- Japanese Translation for Admin

### Enhancements:
- Improved support for applications that have embedded browsers (e.g. Outlook)
- DNS Settings for Proxy coming from the host in the proxy, DNS Caching
- Fonts improved
- Clipboard Improvement
- File Download Behavior Change (per site and not file)
- New Component: Collector (monitor HW Resources Utilization on each node)
- Active Directory errors improvements
- Added support for HTTP Basic authentication
- File Transfer Report includes File Uploads
- XFF Header sent by default to avoid Google Captcha Request
- Infrastructure Upgrade for Improved Security 

### Fixed:
- Fixed various Download and Sanitization Issues

## [Prod:17.12-Build-225] - 2017-12-10
### New Features:
- New message confirmation instead of "The browser prevented opening a tab"
- Open link seamlessly, without a popup warning
- Header forwarding options (Client-IP, User, XFF)
- Support external syslog server
- Support long term reports
### Enhancements:
- Multi-Machine: 
  - Support adding machines using certificate
  - ericomshield-setup-node.sh --status command
  - shield-nodes.sh [-add-label] [-remove-label] [-show-labels] commands
- CTRL+X cut notification
- Upload notification spinner
- Reduced CPU usage per Remote Browser
- Admin - Profiles section - additional settings and improved validation.
- Improved fonts display
- Improved stability
- Improved compatibility with Internet Explorer
- Improved support of white listed sites 
- Improved reports - added filters and additional info
- Clipboard enhancements
### Fixed:
- Search in Online Documentation
- Improved editing on Office Online 
- Sometimes ENTER, BACKSPACE and DELETE keys are not working
- Japanese keyboard bug fixes
- Display current version on all views

## [Prod:17.11-Build-203] - 2017-11-6
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
- Autoupdate is not set by default, run the install with -autoupdate to enable it
- If Multi-Network Cards are detected during the install, the user is asked to select the IP to use

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

