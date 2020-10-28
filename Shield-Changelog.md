# Changelog

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Rel-20.10.685] - 2020-10-28

### New Features

- Horizontal Pod Autoscaler (HPA) Services on Kubernetes
- External Objects In Whitelisted Domains

### Enhancements

- Set Resource Limit for all PODs 
- Proxy Authorization header is not passed to upstream proxy (QA#728526)

### Bug Fixes

- Fixed: X-Forwarded-For extra character (QA#788852)
- Fixed: X-Authenticated-User format in white
- Fixed: Kibana - missing reports when navigating within the session 
- Fixed: Japanese input bug in Firefox (QA#787953)
- Fixed: consul backup restore back to default the settings on specific machine
- Fixed: Aligning sysctl_common.conf and configure-sysctl-values.sh 
- Fixed: For accesses within the same domain, only the first access is logged (CA0000068373/QA#779601)

## [Rel-20.07.669] - 2020-09-30

### Bug Fixes

- Fixed: auth-proxy runs out of memory (CA0000070324,QA#789057)
- Fixed: Resource limits of es-proxy-auth (CA0000070363,QA#789246)

## [Rel-20.07.668] - 2020-09-02

### Bug Fixes

- Fixed: checkSessionLimit flag doesnt work
- Fixed: delete-shield.sh error

## [Rel-20.07.667] - 2020-08-05

### New Features

- License Enforcement Changes
- X-Authenticated-User Header Format
- Headers for Resources in White
- TLS 1.3 Support

### Enhancements

- Helm v3
- DNS lookups even when using upstream proxy
- Increase Memory Limit for Ext-Proxy
- Many Crystal fixes
- Added Log Navigation (in session)

### Bug Fixes

- Fixed: CA Certificate Issues
- Fixed: Admin FQDN Cert not working
- Fixed: CDR Opswat Fixes
- Fixed: Workaround for Rancher Issue for Offline Deployment
- Fixed: All google/gmail sites causing issues
- Fixed: Google drive issue
- Fixed: ELK node scheduling rules
- Fixed: Phishing Read-Only - clipboard is not disabled
- Fixed: Analyzer Health Check skips connectivity test (even when there is no upstream proxy) 
- Fixed: Every Save in the Admin adds characters to ca-passphrase key in consul (\) 
- Fixed: CA0000069129: Japanese Keyboard Can not delete characters with Back space key (QA#782283)
- Fixed: CA0000069157: Scaler doesnt clean Succeeded pods which do not have a parent Job 
- Fixed: CA0000068374: In rare cases, when you reboot Shield, CDR settings are not updated and files cannot be sanitized.(QA#778847)

## [Rel-20.05.649] - 01-06-2020

### New Features

- Support for SAML Authentication - Proxyless

### Enhancements

- AdminUI - Reports | System section has been removed
- Consul backup location (on new installation): /home/ericom/ericomshield
- Multi Tenant - Multiple Proxy/Managements can work with a single Farm /ELK
- X-Authenticated-User Format
- New Rancher version: 2.3.7
- Integrate NetSTAR Category List Update
- Shield Support for SUB CA

### Bug Fixes

- Fixed: Alt Gr Key (issue on Swiss Keyboard)
- Fixed: Problem with web.whatsapp.com 
- Fixed: Can't edit Read-Only rule for categories
- Fixed: False Votiro Alerts
- Fixed: OPSWAT keepalive URL fails against older versions
- Fixed: Crystal - URL with anchor in wikipedia.org
- Fixed: Crystal - video does play and pause repeatedly
- Fixed: Crystal - Autoplay videos from ynet keeps doing play/pause
- Fixed: Crystal - Youtube embed video not visible while playing
- Fixed: Crystal - Mouse coords are off in some iframes. 
- Fixed: Crystal - Scrolling bar is in the left side of the page instead of right for some URLs
- Fixed: Crystal - Video in iframe fullscreen
- Fixed: Crystal - Multi select list is not working as expected
- Fixed: Crystal - Document selection color

## [Rel-20.03_Build_641] - 06-05-2020

### Enhancement - Rel-20.03.2

- SHIELD-5920 - Supports offline deployment (including install on clean ubuntu (not ova))
- shield ova: Support for VM with more than 8 CPU

## [Rel-20.03_Build_639] - 21-04-2020

### Bug Fixes - Rel-20.03.1

- Fixed: Stream Mode is sending Video in Frame Mode (QA#774332)
- Message on Old Chrome Version (#669)


## [Rel-20.03_Build_638] - 06-04-2020

### New Features - Rel-20.03

- Support Shield in Split Mode Deployment (Management + Proxy  | Browser Farm + ELK)
- Reports New visualization with Export to CSV option
- Proxy-Authorization Headers Support
- New CDR Vendor Support: Opswat
- Offline Deployment Support: OVA for Offline Repository
- Rancher High Availability (Cluster) Support

### Enhancement - Rel-20.03

- Have all shield-perf counters on the connetionInfo index
- Connectivity Test - Configurable.
- Max Browsers Count should be based on the Allocatable CPU.
- Shield Installer (in Docker).
- Customized ext-proxy error page.
- Session History report - Remove duplicities from report content

### Bug Fixes - Rel-20.03 

- Fixed: Shield Alert emails are not received
- Fixed: Link for more information from phishing updated
- Fixed: Crystal - many input types can't be edited
- Fixed: Crystal - convert relative mouse coordinates
- Fixed: Crystal - video auto play on ynet
- Fixed: Crystal - cannot type in some inputs (e.g. google login username)
- Fixed: Alert on Connectivity when there is no connection on Management Server
- Fixed: Squid errors due to certificate issues (ifilter)
- Fixed: Admin UI - Applications table - search does not work
- Fixed: Sasa - Remove "Embedded files not supported and were removed" message
- Fixed: Sasa - Doesn't support file type conversion
- Fixed: Policies exporting - double-byte characters in comments are not supported
- Fixed: OVA online - fail to update shield.

## [Rel-20.01.2_Build_622] - 17-02-2020

### Bug Fixes - Rel-20.01.2

- Increase Health-check Frequency for Remote Browser

## [Rel-20.01.1_Build_621] - 16-02-2020

### Bug Fixes - Rel-20.01.1

- Fixed: Allow elasticsearch to failover to another node
- Fixed: Phishing message point to new page
- Fixed: Applications report is empty in Dev616 although I used several applications
- Fixed: Authentication window appears twice and more when open white url
- Fixed: portal.azure.com login impossible

## [Rel-20.01_Build_616] - 03-02-2020

### New Features - Rel-20.01

- ELK Automatic Snapshots
- OVA - Offline
- New Rancher Version: 2.3.5
- Admin UI for hosted customers

### Enhancement - Rel-20.01

- Default Votiro URL changed to cdr.ericom.com
- Remote Browser Scaler - Algorithm Improvement
- Reports - organize the connections and users under one category
- Block activation of named user license if no AD
- Phishing Global Service
- Google WebRisk API working with Local DB
- Monitoring & Alerts for Hosted environment
- Admin User is still available when LDAP Login is defined

### Bug Fixes - Rel-20.01

- Fixed: Admin UI Dashboard doesn't show Nodes table when system has a node with no labels
- Fixed: CDR settings are not kept and not restored
- Fixed: File preview - display issues

## [Rel-19.12.1_Build_606] - 12-01-2020

### Bug Fixes - Rel-19.12.1

- Fixed: Users cannot login to google services (e.g. gmail)
- Fixed: PDF file content doesn't show (font missing)

## [Rel-19.12_Build_605] - 06-01-2020 - Kubernetes Version Only

### New Features -Rel-19.12 

- Phishing Detection and KPIs using Google Web Risk API
- New Reports for Risky Sites 
- New Policy Action: Read Only
- Hardened and Offline OVA Support (Ubuntu 18.04)
- Load Balancer for Votiro
- TechPreview: Crystal - Many Improvements and Bug Fixes

### Enhancement - Rel-19.12

- Admin UI: EULA Approval in the first login
- Admin UI: Policy Changes: Improve UI and UX
- Install-shield option for using Rancher CLI (-R)

### Bug Fixes - Rel-19.12

- Fixed: deploy-shield should wait for tiller to be ready
- Fixed: Google spreadsheets - double click is mandatory for entering input
- Fixed: Microsoft Team doesnt work well
- Fixed: Services - online doc link should be customizable
- Fixed: Application rules force browser (QA#757044)
- Fixed: Sometimes images cannot be downloded

## [Rel-19.11_Build_590] - 27-11-2019 - Kubernetes Version Only

### New Features - Rel-19.11

- Change Intelligent Mode License Definition
- Admin: Services Page
- Admin: Users Reports (Active Session, Active Users, Named Users)
- TechPreview: Retrieve Original Files (CDR) from the Admin
- TechPreview: Crystal - Many Improvements and Bug Fixes

### Enhancement - Rel-19.11

- ELK Stability Improvements and Bug Fixes
- Votiro version is now displayed at the admin
- Monitor Shield Services in Kube
- New Alerts:
    - "Some replicas of the following services are not running: ServicesList"
    - "There are currently no standby remote browsers"
- Removed two alerts:
    - "High number of critical errors in the log"
    - "Some URLs loaded too slow by the Browsers Farm"
- Hide anti-phishing settings from Admin when there is no Category license
- Dashboard Notifications - Add start timestamp
- Health-Check point for Shield http://<SHIELD_SERVER>/health

### Bug Fixes - Rel-19.11

- Fixed: system ID change when redeploy shield
- Fixed: Kibana in elk namespace crash
- Fixed: Kibana server is not ready yet
- Fixed: Kibana time out after restart shield
- Fixed: Phishing section is missing from the admin
- Fixed: outlook.com is stuck
- Fixed: Scaler on AWS fails to calculate max remote browsers : "Missing credentials in config"
- Fixed: "Must connect using SSL encryption" message
- Fixed: flash on http://www.mext.go.jp/programin/app/
- Fixed: google docs - conversion candidate window
- Fixed: Blocked page on IE receives an error HTTP 403 instead of the Blocked Page
- Fixed: Align all alerts to work in "Dynamic Nodes" mode
- Fixed: Indicator spins forever when edit application table
- Fixed: members of Domain Users AD group are not being published

## [Rel-19.09.6_Build_579] - 14-11-2019

### Bug Fixes Rel-19.09.6

- Fixed: Authproxy issue for Swarm

## [Rel-19.09.5_Build_579] - 28-10-2019

### Bug Fixes Build_579

- Fixed: cookies for init domain in redirect mode
- Fixed: Video problems on MacOS

## [Rel-19.09.4_Build_578] - 10-10-2019

### Bug Fixes Build_578

- Fixed: Missing syslog and reports - White

## [Rel-19.09.4_Build_577] - 08-10-2019

### Bug Fixes Build_577

- Fixed: Default application policy bug #7436

## [Rel-19.09.4_Build_576] - 06-10-2019

### Bug Fixes Build_576

- Fixed: Missing syslog and reports
- Fixed: 'too many open files' error
- Fixed: Shield Setting Lost

## [Rel-19.09.2_Build_572] - 23-09-2019

### Bug Fixes-19.09.2
- Fixed: Enabled self monitoring for fluent-bit and add livenessProbe for this container
- Fixed: Analyzer is not working on swarm and break the admin
- Fixed: Application report is not working on swarm
- Fixed: Backup/Restore issue
- Fixed: Daily back up is missing
- Fixed: Add proxy.py to ova

## [Rel-19.09.2_Build_572] - 23-09-2019

### Bug Fixes 19.09.2

- Fixed: Shield-management-consul on farm node
- Fixed: Duplicate application logs
- Fixed: Change user.max_user_namespaces on CentOS only
- Fixed: Align release names in Deploy/Delete scripts

## [Rel-19.09.1_Build_570] - 18-09-2019

### Bug Fixes 19.09.1

- Fixed: Application policy disappears upon restart (QA#746987)
- Fixed: Admin UI: Missing node summary and node list at the dashboard
- Fixed: Admin UI: Advanced Link is not Working (QA#744973)
- Fixed: Syslog report - missing data
- Fixed: Some periodic tests should be skipped when using upstream proxy
- Fixed: user.namespaces in centos need to be increased
- Fixed: Align release names in Deploy/Delete scripts
- Fixed: HA: Improvement on Node Failure Detection
- Fixed: HA: No logging until restart fluent-bit on all nodes
- Fixed: HA: CEF gives "unknow certification authority" error
- Fixed: HA: Farm is not available "oops" message - shown with 2/3 nodes available
- Fixed: No alerts when periodic tests failing
- Fixed: Scaler Fixes for load test issues
- Fixed: Ldap proxy fails to write AD group list in Consul with big number of Groups
- Fixed: Ldap proxy fails to bind to AD if Admin password contains double quotes character(s)
- Fixed: File preview is not working in proxyless mode
- Fixed: Documentation: Calico in OVA Documentation
- Fixed: Documentation: SSD is recommended, not required

## [Rel-19.09.566] - 11-09-2019

### New Features 19.09

- Dashboard Redesign
- Session Report
- Restore from the Admin

### Enhancement 19.09

- Install Docker 19.03.1 (latest)
- Missing Reports on Kube
- Added Analyzer to Kube
- Alerts when named users license limit is met
- Alert for URLs loaded slowly in kube is not working
- Alert for too many errors in logs in kube is not working
- XFF sent on redirect mode
- Shield setup: Bonding Interface Support

### Bug Fixes 19.09

- Fixed: Admin - Import policies is not working when the file includes bad data
- Fixed: Admin - support override for categories
- Fixed: Website - Shopping Site - Half page missing - (NTLN)
- Fixed: HA - No Browsers when stopping one Node
- Fixed: Printing is not possible if Sanitization is not available
- Fixed: Web mail (IMAP) - conversion candidate window
- Fixed: Website: fujifilm - black areas in the screen
- Fixed: Kube - White URL's are not in conections reports
- Fixed: Kube: Analyser to show docker version
- Fixed: 'Inconsistent User Profiles' alert details will show both sAMAccountName/userPrinicipleName
- Fixed: HA -Scaler doesn't create browsers when pod in pending (terminating) state

## [Rel-19.07.1-Build_554] - 07-08-2019

### Enhancement 19.07.1

- Consul Backup: expose local folder to Custom Values #6877

### Bug Fixes 19.07.1

- Fixed: Various fixes in High Availability
- Fixed: Session Limit without authentication works with flag (checkSessionLimit: true)
- Fixed: File Preview is not working
- Fixed: Upload function of a specific website do not work (QA#741975)
- Fixed: Admin - import policies is not working (when the file includes bad data)
- Fixed: Sometimes Getting BLANK pages
- Fixed: Not sanitizing password protected zip file if extension is upper case

## [Rel-19.07.553] - 28-07-2019

### New Features 19.07

- Migration to Kubernetes:
  - Support for On-Prem Deployment on Centos
  - New OVA for Shield Kube on Centos
  - Alerts fully supported on Shield on Kube
  - Full Support for Upstream Proxy
  - External Syslog
- Multiple Domain Support
- Multiple Domain Controller (Load Balancing) Support

### Enhancement 19.07

- Enforce Concurrent Sessions per License
- Crystal Mode, various enhancements and improvements
- Remove memory pools from proxy server
- Shield-perf consistent time format
- spellcheck_control.py (QA#737494)

### Bug Fixes 19.07

- Fixed: The profile is change to "All" at export policies
- Fixed: Add sourcehost variable to logstash config
- Fixed: Secured Web Socket (wss) Issue
- Fixed: Zoom is not working with shield
- Fixed: DNS Settings are empty
- Fixed: Burst Events on Cloud are done on UTC instead of Admin Time
- Fixed: Specific site - video auto-restarts after it is paused
- Fixed: 'Internal DNS Address' configuration (QA#738833)
- Fixed: "Route All Connections Via Browsers Farm" with upstream (QA#738778)
- Fixed: dnsmasq name-server settings (QA#738624)
- Fixed: Resource GET flow(white) when there is an upstream proxy (QA#738623)
- Fixed: Admin - Policies - support importing XL amount of policies
- Fixed: Kube - node labels are not working as expected
- Fixed: specific file in korean (.hwp) fails to downloaded with shield

## [Rel-19.06.538] - 26-06-2019

### New Features 19.06

- Migration to Kubernetes:
  - All Components now running on Kube (Management, Shield-Proxy, Shield-Logs, Browser Farm )Orchestration Platform
  - New Instructions for On-Prem Deployment
  - Alerts Support
  - Backup Configuration (Local, SFTP, S3)
  - New ELK Version (Logging Platform)
- Multiple Domain Support (Basic)
- Multiple Domain Controller Support (Basic)
- Shield-Support Script
- support profiles based on X-Authenticated-Groups on https sites
- Admin - Settings - Button to download Shield certificate
- "Authentication Chaining" Support for 'X-Authenticated-Group' HTTP header

### Enhancement 19.06

- Performance Improvement:
  - Page Load
  - Typing
  - Caching HTTPS Resources
  - Faster page load on search engines
  - Crystal: Faster Load Pages
- Autofill improvments
- Remove Session Table from Dashboard (GDPR)
- Send Feedback: Close Windows on Cancel
- AdminUI: Various Enhancements and Bug Fixes

### Bug Fixes 19.06

- fixed: - Session is getting stuck when downlading file with special chars
- fixed: ReadOnly Mode for Phishing Issue
- fixed: OVA - addnodes is missing
- fixed: Ext-Proxy cache https sites
- fixed: Website: <https://www.kddi-dsec.com/> might get stuck
- fixed: Removed capacity alert
- fixed: Secured LDAP (ldaps) Issue
- fixed: Squid crash with upstream proxy

## [Rel-19.05.520] - 22-05-2019

### New Features 19.05

- Admin: Categories merged to Policies Table
- Admin: Applications & Policies - Defaults table merged into main table for improved UX.
- New Virtual Appliance (Shield and Registry) for Offline Deployments (OVA)
- Admin: Support Votiro Named Policy
- Admin: Support Sasa Named Policy (Tech Preview)
- AutoFill Form Data (Tech Preview)
- Admin: Cloud - Resources - Burst Events
- Admin: Could - Dynamic Node Info Table - display node groups deployment in the dashboard"
- Cloud: Migrate Management and Proxy Components to Kubernetes Orchestration Platform (Tech Preview)
- Cloud: Migrate Shield-Log to Kubernetes Orchestration Platform (Tech Preview)

### Enhancement 19.05

- Docker Updated to latest version (18.09.5)
- Computer usernames will not be counted for license
- Applications will not be counted for license
- Page Load Time Improvements
- Update Admin to work on new version of Chrome
- Increase the number of domain policies supported
- Alert: System Capacity has been reached
- Page is not displayed when it is blocked/ white and using Redirect mode
- "Network is slow" message changed
- Always use WSS (WebSockets over SSL/TLS)
- Security: Admin jquery update to 3.3.1
- Allow adding exceptions in proxy.py
- proxy.py supported on Centos/RHEL
- Redirection mode: Blocked pages will be enforced, White pages will be Shielded

### Bug Fixes 19.05

- fixed: Korean Keyboard issues
- fixed: Docker does not start service on CentOS (QA#731188)
- fixed: Log invalid characters in url path
- fixed: Proxy-server out of memory (QA#)
- fixed: Can't update Firefox and Chrome with Shield
- fixed: Windows update failed with shield
- fixed: Safari background tab websocket force disconnect
- fixed: Redirects with utf8 location don't work properly
- fixed: Severe issue at customer required reboot (QA#)
- fixed: Form is not opened as expected (QA#)
- fixed: Shield site is opened as blank page (QA#729084)
- fixed: Resources with accepted invalid certificate don't load
- fixed: Unable to display specific page (white screen) - <https://biz.kddi.com/> (QA#)
- fixed: No need to check health of netstar if not used
- fixed: Phishing - not display notification / warning when categories are disabled
- fixed: Adblock list is not synced to farm
- fixed: don't use ext-proxy in farm mode when adblock is off
- fixed: Authentication popup - maintain in focus w/o messages in the background
- fixed: When Categories are disabled – avoid the check health to Categorization Server
- fixed: When Categories are disabled - Phishing notification/warning malfunction
- fixed: Gmail Printing malfunction
- fixed: Resources with accepted invalid certificate don't load
- fixed: Issues with installation on CentOS and RHEL, related to Phyton dependencies

## [Rel-19.04:Build_502.1] - 2019-04-07

### New Features 19.04

- New Virtual Appliance for Deployments (OVA) (Tech Preview)
- Admin: Cloud: Show Deployment in the Admin (Tech Preview)
- Admin: Cloud: Configuration of browser scaler (Tech Preview)
- Admin: Cloud: Resources - Burst Events (Tech Preview)
- Cloud: Helm Package for Shield (Management and Proxy) (Tech Preview)
- Cloud: Helm Package for Shield (Log) (Tech Preview)

Alpha Ready:

- CDR: SASA Integration (Tech Preview)
- CDR: Support Named Policy (Tech Preview)

### Enhancement 19.04

- Add logging file and size limitations for all services
- Allow setting the locale in Electron/Chromium
- Update Rendering Engine to 4.0.8 to include security fix
- Added support for custom mouse cursor (e.g. Map.baidu.com)
- Use NSS to validate Certificate Authorities
- Update default Bandwidth limit to 10 GB
- Updated text messages -Shield scripts and error messages
- Improve High Availability (2 icap servers)

### Bug Fixes 19.04

- fixed: Google drive is not working with shield
- fixed: Possible fixes for broken sites
- Pre-installation checks - ubuntu 18.04 update
- Intelligent isolation - Do not allow to delete categories

## [Prod:19.02.1-Build-492.5] - 14-03-2019

- AdminUI: Strings not displayed properly in Policy Table
- AdminUI: Translation updates
- Installer: Pre-installation checks - ubuntu 18.04 update
- Installer: dist-upgrade - have an option to cancel it
- Installer: Enable SpellCheck tool update

### New Features 19.02

- New Policy Option for Printing:
  - Disabled: Printing is Disabled
  - Protected: Printing is Enabled if Download is Enabled/Sanitize
  - Enable: Printing is Enabled (regardless of Download Policy)
- License enforcement for intelligent isolation
- Stay in shield on Redirect Mode
- Admin: Configuration of Browser Scaler (Tech Preview)
- Cloud: Show farm sessions data on Admin UI Dashboard (Tech Preview)

### Enhancement 19.02

- Print PDF directly on IE
- Changes in End User Shield Indicator
- Inherit Client Geo Location to the Remote Browser
- Apply bandwidth limit to sessions
- Alert: Browser Farm is not available

### Bug Fixes 19.02

- fixed: Custom Translations are lost during update
- fixed: Tab Limit should be based on GUID when no Auth
- fixed: addnode fix increase the time + add tests to weakup swarm if needed
- fixed: status.sh -e is not working
- fixed: Copy/ Paste on MAC doesn't work properly
- fixed: Override doesn't work on categories

## [Prod:19.01.1-Build-475.4] - 07-02-2019

### Enhancement 19.01.1

- Multiple Syslog Servers Support
- New Translations for Japanese

### Bug Fixes 19.01.1

- Fixed: status.sh -e is not working
- Fixed: Add Node doesnt work sometimes
- Fixed: Improved Multi-Node HA
- Fixed: Chinese Input Issues

## [Prod:19.01-Build-475.1] - 03-02-2019

### New Features 19.01

- Categories (production ready)
- External Browser Farm (on-prem, or Cloud-based) - Tech Preview
- Elastic Nodes Scale for Browser Farm on Cloud - Tech Preview
- Intelligent Isolation Mode
- New File Sanitization Votiro Version

### Enhancement 19.01

- Categories are Enabled by default to support the Intelligent Isolation mode
- Chinese inputs support
- New Ericom Certificate with extended expiration date
- Tab Limit is enforced according to Browser GUID when there is no Authentication
- User's Display name added to reports
- Pre-installation checks - ubuntu 18.04
- Category - search
- Remote Browser Auto-kill

### Bug Fixes 19.01

- Fixed: Failure occurs when returning from NIC down/up
- Fixed: Multi node - when one node is shut down ./status.sh -n doesn't work
- Fixed: Stuck CTRL Key
- Fixed: Blank tab opened after the pop up is displayed
- Fixed: Redirect - Can't download files with space in the name
- Fixed: Chinese - Conversion window position
- Fixed: Japanese - Conversion list window position on FF
- Fixed: Japanese - Suggestion doubled - now need to enter the letter again
- Fixed: Japanese - (Safari MAC) Can't type in alphanumeric mode
- Fixed: Japanese: Alphanumeric characters doubled

## [Prod:18.12-Build-461] - 30-12-2018

### New Features 18.12

- Potential Phishing Detection (Action: Warning, Read-Only, Block) (Tech Preview)
- Categories (Tech Preview)
- Centos/RHEL Support
- Redirection Mode
- End User: Support Multi-Select in Drop Down Lists
- Named User Licensing
- Set Image Quality and FPS
- Exclude IPs for RateLimit
- Browser Farm settings in Admin (Tech Preview)
- Enable/Disable Tech-Preview Features
- Allow End User Shield Indicator ("[]" Symbol Before the URL Name, edited via the translations file)
- Ext-Proxy Logs are collected

### Enhancement 18.12

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

### Bug Fixes 18.12

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
- Fixed: Delete multiple policies lines
- Fixed: When node is not in swarm or no leader, status-node returns a script error
- Fixed: Zip file + password - encrypt password
- Fixed: Mac/Firefox: Scroll is broken after cmd+c
- Fixed: Can print url pdf file when printing is disabled

## [Prod:18.11-Build-436] - 18-11-2018

### New Features 18.11

#### End User Features 18.11

- File Preview

#### Admin Features 18.11

- Maintain customer environment variables during upgrade (proxy, subnet)
- Proxyless Mode (Tech-Preview)
- Votiro New Version: 8.1.1
- External Syslog Configuration from AdminUI

### Enhancement 18.11

- Alert when user is associated to two User Profiles
- Add Display Name and User Profile to the report/sessions list in Dashboard
- Alert end user when Javascript is disabled on the browser (may lead to errors)
- Increase download timeout to 30 min
- Delete "raw" index in ELK prior to update process
- WebService Code cleanup - reduce network usage
- Reset Certificate uploaded and revert to Ericom Certificate
- Verify all certificates exists

### Bug Fixes 18.11

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
