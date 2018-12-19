# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

- Git Issues should be referenced by #
- Main Features/Bug Fixes should have (*)
- User Action Required should have (!)

## [Unreleased]

## [Prod:18.12-Build-4xx] - 30-12-2018

### New Features

- Potential Phishing Detection (Action: Warning, Read-Only, Block) (Tech Preview)
- Categories (Tech Preview)
- Centos/RHEL Support
- Redirection Mode
- End User: Support Multi-Select in Drop Down Lists
- Named User Licensing
- AdminUI: Set Image Quality and FPS
- Exclude IPs for RateLimit
- Browser Farm settings in Admin (Tech Preview)
- New setting: Enable Tech-Preview Features
- Allow to add Indication when browsing using Shield ("[]" Symbol Before the URL Name by default)
- Ext-Proxy Logs are collected

### Enhancement
- It is now possible to sign in to chrome
- Bandwidth Improvements
- Right-Click Open Link without add-block also on page load failed
- Support Right/Left CTRL+Shift combination
- Support ALT + Arrows combinations
- Alert when Votiro license/trial days are over
- Notifier service must run on a management node
- Votiro Anti-Virus Option ('off' by Default)
- Allow clipboard inside the browser
- Print disabled for files in case download is disabled
- File preview -File Size Limitation
- Reset Certificate uploaded and revert to Ericom Certificate

### Bug Fixes

- Fixed: Can't upload .JPG files on Gmail
- Fixed: Can't open PDF file from Google
- Fixed: Timeout Session doesnt work on Website with Popup window
- Fixed: Windows/Firefox : Right click menu is not working properly
- Fixed: Fallback to LDAP is not working
- Fixed: Japanese - Suggestion doubled
- Fixed: Japanese - First letter is doubled in Internet Explorer
- Fixed: Japanese - Output issue
- Fixed: Japanese - Problems with the keyboard
- Fixed: Japanese - IME position
- Fixed: Japanese - IME disabled after typing in the password field
- Fixed: Japanese - the position of the conversion list window is not correct
- Fixed: Japanese - some problems with the positioning
- Fixed: Download zip with password - fix the password dialog
- Fixed: SMTP alert uses auth when no auth is defined
- Fixed: Right click -> paste : dialog to use ctrl v is not openning
- Fixed: Import policies - translations issues
- Fixed: Disable the slow network message does not work
- Fixed: Policies - delete multiple lines - does not work as expected
- Fixed: When node is not in swarm or no leader, status-node returns a script error
- Fixed: Zip file + password - encrypt password
- Fixed: Mac/Firefox: Scroll is broken after cmd->c
- Fixed: Can print url pdf file when printing is disabled

## [Prod:18.11-Build-436] - 18-11-2018

### New Features

#### End User Features

- File Preview

#### Admin Features

- Maintain customer environment variables during upgrade (proxy, subnet)
- Proxyless Mode (Tech-Preview)
- Votiro New Version: 8.1.1
- External Syslog Configuration from AdminUI

### Enhancement

- Alert when user is associated to two User Profiles
- Add Display Name and User Profile to the report/sessions list in Dashboard
- Alert end user when Javascript is disabled on the browser (may lead to errors)
- Increase download timeout to 30 min
- Delete "raw" index in ELK prior to update process
- WebService Code cleanup - reduce network usage
- Reset Certificate uploaded and revert to Ericom Certificate
- Verify all certificates exists

### Bug Fixes

- Fixed: Uploading files should ignore timeout
- Fixed: LDAP Login related bugs
- Fixed: Japanes Keyboard Issues
- Fixed: Website Salesforce - several issues (Spellcheck, create PDF invoice, cannot set value in dropdown)
- Fixed: Website Facebook related issues (playing videos & upload photo/video)
- Fixed: Upload into iFrame
- Fixed: Zip with password didn’t work properly
- Fixed: Links are downloaded when they should be opened - fixed
- Fixed: Several Broken Websites (Foxnews, Zoominfo, etc)
- Fixed: Custom trust certificate is not working with shield
- Fixed: No mail alert on a machine with upstream proxy

## [Prod:18.10.2-Build-413.4] - 23-10-2018

- Fixed: Custom Trust Certificate is not working with shield
- Fixed: QA#708355 Failure addnoteds.sh -b

## [Prod:18.10-Build-413.2] - 14-10-2018

### New Features 18.10

#### End User Features 18.10

- Paste image to Shield
- Send Feedback (from right click)
- Pause Shield and Reload (for evaluations)

#### Admin Features 18.10

- Support already authenticated users by downstream proxy (using headers)
- Support for local registry/cache for docker images
- Votiro new version: 8.1.0

### Enhancement 18.10

- Performance Improvements:
- - Several improvements for faster page loading
- - Lower FPS settings
- - Lower FPS during scrolling
- - Reduce bandwidth usage
- Pre-check is not run by default on update
- Admin UI - Validation of domain value in policy
- Admin UI - Import policies should display the name of the file
- Admin UI - New Japanese Translations
- Data retention for basic authentication

### Bug Fixes 18.10

- Fixed: Several broken websites
- Fixed: Delete raw index in ELK if conflicts
- Fixed: Hide context menu on scroll
- Fixed: Japanese character conversion candidate display position
- Fixed: Underline of unconverted character string
- Fixed: Prevent outside modal clicks and scrolls
- Fixed: Several LDAP login fixes
- Fixed: When pasting a big amount of text the page is not responsive
- Fixed: Drop Down list is repositioned differently according to zoom

## [Prod:18.09-Build-399.1] - 16-09-2018

- Support Nested Groups in Active Directory

## [Prod:18.09-Build-399] - 06-09-2018

### New Features - 18.09

#### End User Features - 18.09

- Save Image from Shield
- Copy Image from Shield
- Customized Error Pages (DNS failure, ICAP Error)

### Enhancement - 18.09

- Added Font Missing in Shield
- Improve Font Display (fonts, color, spacing)
- Fullscreen message is now more visible
- Support PDF in iframes
- Improved DropDown list
- Updated dialog for opening new tab
- Improved notification on file downloads
- URL schemes support
- Improve internal communication (decrease bandwidth usage)
- Squid logs size are now rotated
- Support certificate chain in Custom Trust Certificate
- Improved support for Admin LDAP login

### Bug Fixes - 18.09

- Fixed: Broken Websites (el-al, whatsapp, pinterest, adp, Bank Leumi, Sharepoint, etc)
- Fixed: Bandwidth Usage on Scrolling and Cursor Blinking
- Fixed: Slow scrolling on high latency
- Fixed: Broker/ICAP/CEF crash on missing default language
- Fixed: Error while saving Japanese translations

## [Prod:18.08-Build-388.2] - 19-08-2018

### New Features - 18.08

#### End User Features - 18.08

- CDR blocked files notifications include additional details
- Support file upload to complex pages that have iFrames
- CDR notifications to include file name for improved UX
- Slow Network message to End-User

#### Admin Console - 18.08

- Admin login support LDAP
- New Errors Report was added
- Added an option to route all traffic (including white-listed) via the Browser farm
- Added an option to block sites with bad certificate in the policies
- Applications table – add a rule for application as a 'browser'
- Validation of CA certificate
- CDR component can be defined directly or via upstream proxy
- Limit system capacity according to CPU and Memory
- Changes XFF and Client-IP to be forward by default

### Enhancements - 18.08

- Two factor authentication support
- Improved page load times
- Add error for the user in case some or all files inside a zip file is being blocked
- Sanitization notification is shown faster and remain until the download to the end user is done
- Bypass upstream proxy for CDR
- Deployment:
  - Full support for upstream proxy
  - Improved Add-Node
  - Fix download docker images on slave nodes
  - Fixed configuration lost after adding nodes

### Bug Fixes - 18.08

- Fixed: Many broken sites
- Fixed: “loaded dictionary for locale us-en” error
- Fixed: Limit Logs size for ELK to reduce high disk usage
- Fixed: Backup issues
- Fixed: Timeout occur during join new node to cluster #3840
- Fixed: Bluecoat firewall cause all urls to be considered as app, hence all are white apps
- Fixed: QA#687503 PDF Printing Issue

## [Prod:18.07.1-Build-368] - 15-07-2018

### Enhancements - 18.07.1

- Updated japanese translation
- NTLM is off by default

### Bug Fixes - 18.07.1

- fixed: local browser stuck after running long time in Background
- fixed: Updated Remote Browser to support Upstream proxy
- fixed: Character conversion problem with function key f6 in chrome
- fixed: QA#688697 About combination key
- fixed: QA#688638: Undefined Japanese - conversion character is deleted on IE
- fixed: Typing in Japanese issue 2

## [Prod:18.07-Build-366] - 08-07-2018

### New Features - 18.07

- End User:
- Localization support for end user texts (context menu, web pages generated by shield, etc)
- Timezone Support
- Context menu allow user to select UI language
- adBlocker can be paused by end-user
- Admin:
- Import/Export Policies
- Support for shield to use Customer CA with password
- Admin - support additional CDR solutions
- Support Checkpoint SandBlast for file Sanitization
- Limit the amount of Tabs a User can open
- Support ADblock in policies
- Ability to install and update on a Specific Release branch
- Health-Check point for Shield (<http://shield-server-ip/shield-stats>)
- Pre-install check (before docker install)
- Docker Installation w/o internet

### Enhancements - 18.07

- Alert by email Improvements
- Performance Analyzer tool: <http://shield-perf/>
- Clean used docker images/containers (maintenance)
- Data retention for basic authentication
- Netdata is now an optional service
- Reduce service images size
- Set Trust all for XFF Forwarding
- Removed ericom.com and google.com from connectivity tests
- Enable cookies and allow_direct_ip_address by default
- X-Forwarded-For forwarding in https
- Default NTLM fallback set to false

### Bug Fixes - 18.07

- fixed: Shield working with Upstream Proxy
- fixed: pre-install-check doesnt work with US proxy
- fixed: Youtube is getting stuck
- fixed: Japanese - alt+kana roman key type the current mode on IE and Edge
- fixed: QA#688618: Shift key is keeping pressed issue with Roman input mode
- fixed: QA#688697 About combination key
- fixed: QA#688638: Undefined Japanese conversion character is deleted
- fixed: QA#689263: There is a problem with the operation of the "Henkan" key (conversion key).
- fixed: QA#687279: Japanese character conversion candidate display position
- fixed: QA#688638: Undefined Japanese conversion character is deleted
- fixed: QA#687132 repeated with TAB
- fixed: QA#687279: Japanese character conversion candidate display position
- fixed: Japanese key combinations: space after shift+kanji
- fixed: Japanese press escape while in composition mode makes copies of text
- fixed: can't type ä, ü, ö special characters in shield using FF
- fixed: Uploading a file too big fails with Internal error
- fixed: Upload big file is failing
- fixed: Drive speed test - syntax error

## [Prod:18.05-Build-344] - 27-05-2018

### New Features - 18.05

- Applications Policies:
  - Allow/Block any desktop application (using HTTP) in Shield
  - Skip authentications for specific Applications
  - Application Report log all Application requests
- Performance Improvement
  - Embedded DNS for better performance
  - DNS (Internal/External) configuration in the Admin
  - Ad-Blocker
  - Resources Saver Timeout (decrease FPS on Idle Browsing Session)
  - After Idle Timeout: Reload on click anywhere in the page
- Notification and Alert by:
  - Slack
  - email
  - POST
- Analyzer Report
- HTTP Headers (Forward/Set/Remove)

### Enhancements - 18.05

- End User:
- Show hovered links in bottom status bar
- Support for spellcheck - English(US) only
- Admin:
- DC Admin password is hidden
- Refresh AD Cache from the Admin UI
- Alerts are sent to Syslog
- Support per node alerts (CPU, Memory & Disk)
- Periodic Test are now configurable
- Japanese Translation for the Admin
- Send Anonymous Feedback - false by default
- Block ftp protocol (configurable in the admin)
- License based on User (when Authentication is enabled)

### Bug Fixes - 18.05

- Fixed: When not typing the full URL, redirect fails
- Fixed: Page display is slow when press on back arrow
- Fixed: SHIFT+left click not working well with Office online
- Fixed: Can't create new account for google drive with shield
- Fixed: Japanese - alt+kana roman key type the current mode

## [Prod:18.04.1-Build-312.3] - 2018-04-22

### Bug Fixes - 18.04.1

- Pool Management: Bug fixes (After Reboot, System Capacity, etc)
- Fixed: Chrome version used by shield should be updated
- Fixed: Allow IE11 with compat user agent (inc. apps)
- Fixed: Admin - FQDN is updated - add pop up message and reload page
- Fixed: Netdata port is not published

## [Prod:18.04-Build-312] - 2018-04-08

### New Features - 18.04

- Fast Media streaming (this allows client side rendering of media, improving user experience and reduce system resource usage)
- New policy options:
  - Printing Enabled/Disabled Policy
  - Exception List for https w/o Trusted Certificate
  - Add Media steaming option in the policies
- Shield Ready Tool
  - Pre-install-check enhancements
  - Admin Analyzer
  - Periodic checks
  - Embedded Speedtest Media page to examine offline experience
- Admin Console supports HTTPS only
- Admin: Change Password
- Support for shield to use Customer Certificate (CA)
- Added support for secured LDAP
- CDR High Availability
- Remote Browser Pool Management (New Design)
- New Shield CLI Commands: (start.sh/update.sh/addnodes.sh/nodes.sh/etc)

### Enhancements - 18.04

- System Upgrade (new design)
- Added fonts for emojis, fonts-ipafont-gothic, fonts-ipafont-mincho
- Admin Updated Japanese translation
- Alerts are sent to Syslog
- Show hovered links in bottom status bar

### Bug Fixes - 18.04

- Fixed: Caching mechanism
- Set language browser property from client
- Keyboard fixes
  - Fixed: Typing issue on IE and Edge
  - Fixed: The cursor does not move when entering double-byte space
  - Fixed: Character conversion problem with function key
  - Fixed: Ctrl+shift+arrows issues
  - Fixed: Japanese henkan key doesn't work as expected
  - Fixed: Japanese commit mixup hotfix
  - Fixed: Left arrow issue when using Japanese
  - Fixed: Does not automatically change the input mode in password field (QA#684141)
  - Fixed: Korean space typing issue
  - Fixed: Korean - ctrl A doesn't work as expected
  - Fixed: Korean - typing alpah numeric full width is not working in chrome

## [Prod:18.03-Build-292] - 2018-03-11

### New Features - 18.03

- New Virtual Appliance for Quick Evaluation (OVA)
- Embedded Speedtest <http://proxy-server-ip:8185>

### Enhancements - 18.03

- Improved Pre-Install Checks (Kernel Version, Virtualization platform, Gathering some system information, Testing cpu performance)
- Remote Browser - Accept invalid certificates using dialog
- Improved Backup Mechanism (Daily Backup for last 10 days)
- Enhanced support for Japanese, Korean and Thai (fonts, IME & keyboards)
- Experimental upload alerts to an external Database
- Admin - Dashboard - When an alert includes a URL, a "Details" column appears in the notification table
- Admin - Settings - Content Isolation
- Admin - Settings - Upstream proxy settings are displayed only if proxy is enabled
- Admin - Reports - New report for system alerts
- Admin - Profiles - Generate the keytab file command
- Admin - Proper message when Admin backend is not working instead of Invalid Credentials
- New Translation for Japanese

### Bug Fixes - 18.03

- Fixed: Windows Update is blocked by Shield
- Fixed: Going out of fullscreen, session is displayed on just a portion of the page
- Fixed: Page is refreshed from time to time
- Fixed: No preview for gmail attached PDF
- Fixed: Browser stuck dragging in SHIFT/CTRL + click link
- Fixed: High Number of Critical Error Alert is confusing #2184
- Fixed: Office online right click menu copy paste - shows but does not function
- Fixed: Authproxy memory leak on reload
- Fixed: Cross Window - Cisco Login

## [Prod:18.02-1-Build-280.3] - 2018-02-20

### Enhancements - 18.02.1

- Pre-check Installer Shield #2068
- Pre-install check ubuntu and kernel version
- Added alert when system requires activation
- Implement Keepalive with Votiro Server
- Blacklist Policy rows should be also strikethrough
- Publishing dynamic PAC files

### Bug Fixes - 18.02.1

- Duplicate Policies when using profiles (identified as a cookies issue)
- Downloads of direct links do not work : "Download Disabled" message
- Open new tab? notification is displayed when open link with middle click
- Cross windows -booking.com
- Emirates.com - Can't click on the website
- Fixed rare broker crash
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

### New Features - 18.02

#### End User Features - 18.02

- Improved Cookies support (performance)
- Improved performance
  - Caching feature (configurable in the Admin)
  - New PAC file (no DNS)
- Improved Scrolling (lowering quality during scroll)
- Zoom with ctrl+mouse
- Cross Windows Issues fix
- Added more User-Agent for Applications detection (e.g. Dropbox)
- Korean Support

#### Administrator Features - 18.02

- Support Large Deployments (thousands of LDAP groups and users)
- Cookies are disabled by default for improved Performance and Security
- Min Available Browsers auto-calculated (minimum 20)
- AdminUI:
  - Background Tab Timeout (Suspend) can be defined in policy (per Domain/per User Profile)
  - Added Alerts infrastructure, and 5 indicators to the Admin UI
  - Added data collection for : totalDiskMB, diskUsage, networkRxBytesPerSec, networkTxBytesPerSec, upTime
  - Added alert for Active Directory binding failure
  - Added disk capacity and usage (data collection and display in the Admin UI)
  - Browsers farm overloaded alerts per resource (memory, cpu, disk)
  - Implement Keepalive with Votiro Server
  - Set background colors for nodes table values based on alerts thresholds.
  - White mode indicator inside admin policy table. (details)
- Backup/Restore Configuration feature
- Full support for Upstream proxy
- Support Upstream proxy client certificate + trusting customer CA certificate (Admin side)
- New Docker Version 17.12
- New Version of CDR (Votiro 7.2.1)
- NetData Customized to show only relevant data
- Ext-Proxy Improvements (High-availability, Caching, DNS Support)

### Bug Fixes - 18.02

- Fix Right-Click on hovered links
- Wrong link to download dropbox #1803
- ericom.com is in white mode when using IE 11
- Blank screen from Oktopost #1806 - set language in browser
- CTRL+Click on a link should open in new tab #1581
- Scroll up/down is not working with shield for some url #1269
- Pressing Shift+click should open a new window #1269
- Support "Find in page" CTRL+F #354
- Administrator:
  - Admin UI sometimes doesn't display data - when admin show no data #1725
  - CTRL+Click on a link should open in new tab #1581
  - Default timeout waiting for sanitization is now 10 minutes (was 5 ) #1660
  - Multi-Machine Deployments bug fixes
  - Caching logic improved
  - No Error for Black list URLs fix

## [Prod:18.01-Build-249.5] - 2018-01-07

### New Features - 18.01

- Pre-installation checks are performed before installation.
- Background tabs are handled with dedicated timeouts (for edit and for read-write tabs) and become dormant when these timeouts are met. This is done to reduce hardware usage and improve resources management.
- Resource computation - CPU and memory usage is constantly monitored and displayed in the dashboard. Number of available standby remote browsers is defined by this information.
- Upstream Proxy - when an upstream proxy is used, Ericom Shield will use it to connect to the internet.
- Dashboard now includes more details about the system, including CPU and memory, total and average. Nodes table was also updated to include more data.
- Links and pop ups are opened seamlessly, except for certain cases where this is technically problematic - then a relevant message is issued to the user, to allow pop-ups per the specific site.
- Added support for Zoom in Browser and DPI Settings. Zoom can be changed using keyboard, mouse & browser.
- Japanese Translation for Admin

### Enhancements - 18.01

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

### Fixed - 18.01

- Fixed various Download and Sanitization Issues

## [Prod:17.12-Build-225] - 2017-12-10

### New Features - 17.12

- New message confirmation instead of "The browser prevented opening a tab"
- Open link seamlessly, without a popup warning
- Header forwarding options (Client-IP, User, XFF)
- Support external syslog server
- Support long term reports

### Enhancements - 17.12

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

### Fixed - 17.12

- Search in Online Documentation
- Improved editing on Office Online
- Sometimes ENTER, BACKSPACE and DELETE keys are not working
- Japanese keyboard bug fixes
- Display current version on all views

## [Prod:17.11-Build-203] - 2017-11-6

### New Features - 17.11

- User Authentication:
  - Basic Authentication (User Name/Password)
  - LDAP
  - Kerberos
  - NTLM (fallback)
- User Profile
- Multi-Node Support (Scalability and High Availability)
    - Prepare Node with Ubuntu, Run PrepareNode script on it
    - Run sudo ./ericomshield-setup-node.sh -ips xxx.xx.xx.xx,yy.yy.yy.yy -mng -b -sc
    - <https://github.com/EricomSoftwareLtd/Shield/blob/master/README.md>
- Internet Explorer Mode
- File Sanitization (CDR Votiro) settings in Admin UI
- File Sanitization (CDR): Password Protected files support
- Admin UI: Added "comment" field to policies. (removed "auto" column) #887
- PAC File: Download and Upload from the admin
- File Upload Support #350

- New Module: Web Service
    - Allows to download the certificate from: http:<SHIELD_SERVER>/install-certificate or directly from: <http://SHIELD_SERVER/ericomshield.crt>
    - Allows to download the auto-generated PAC file from: http:<SHIELD_SERVER>/default.pac
- Japanese Keyboard Support
- New Module: shield-maintenance
    - Cleans old docker images and used Remote Browsers

### Enhancements - 17.11

- Backup / Resore verify that the settings are ok before creating a backup
- Propagate Client IP, XFF (X-Forward-For)  to external proxies #1078
- Use settings from host's /etc/resolv.conf for DNS resolver in proxy-server
- Dashboard refresh for every 5 seconds #787
- Adding Flag to Restart the system during upgrade when required
- Autoupdate is not set by default, run the install with -autoupdate to enable it
- If Multi-Network Cards are detected during the install, the user is asked to select the IP to use

### Fixed - 17.11

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
