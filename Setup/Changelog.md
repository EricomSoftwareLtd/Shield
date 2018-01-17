# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).
- Git Issues should be referenced by #
- Main Features/Bug Fixes should have (*)
- User Action Required should have (!)

## [Unreleased]

## [Dev:Build_259] - 2018-1-17
- Fixed yml file

## [Dev:Build_258] - 2018-1-16
- Multi-Machine: Old Configuration is loaded when Admin move to another node #1816
- When killing all consul-server containers the browsers and the shield_authproxy didn't started. #1538
- Put the backup on the host (e.g. /usr/local/ericomshield/backup ) #1608

## [Dev:Build_257] - 2018-1-16
- Dashboard indicators #1847
- Add certificate authentication support #1867
- Support upstream proxy client certificate + trusting customer CA certificate #1797
- Wrong link to download dropbox #1803

## [Dev:Build_256] - 2018-1-16
- Start using votiro 7.2.1 #1501
- Enable caching in shield-squid-ext #1857
- Fix electron-rebuild step in CEF build #1865
- Improve default.pac preformnce #1850
- Removed "should fail the download of 'MyZip.zip' which is password protected when using Votiro cloud server" test #1851
- Added Votiro URL to error message when failing to upload the file

## [Dev:Build_255] - 2018-1-14
- (*) Removed local dir for consul, added restore to Admin
- (*) Dashboard indicators (1535, 1790)
- Added alerts infrastrcture, and 5 indicators to the Admin UI
- Added data collection for : totalDiskMB, diskUsage, networkRxBytesPerSec, networkTxBytesPerSec, upTime
- moved alerts to a dedicated table #1535
- Added alert for Acrive Directory binding failure #1535
- Added disk capacity and usage (data collection and display in the Admin UI) #1535
- Browsers farm overloaded alerts per resource (memory, cpu, disk) #1535
- Set background colors for nodes table values based on alerts thesholds.
- Comment proxy chain remote dns and proxy dns
- Add shield-netdata container image - cleanup errors #1791

## [Staging:18.01-Build_249.5] - 2018-1-14
- Browsers service remove problem #1830
- Comment proxy chain remote dns and proxy dns

## [Dev:Build_254] - 2018-1-10
- Browsers service remove problem #1830
- Remote Browser will not ask for password when sanitizing password protected archive files #1831
- ericom.com is in white mode when using IE 11 #1749
- Autentication proxy crashes when disable and then enable ext proxy #1827

## [Staging:18.01-Build_249.4] - 2018-1-10
- (*) Fixed Admin crash #1725

## [Dev:Build_253] - 2018-1-10
- (*) Fixed Admin crash #1725
- Support upstream proxy client certificate + trusting customer CA certificate #1797 (Admin side)

## [Dev:Build_252] - 2018-1-9
- (*) External Proxy Support (in internal proxy) #1574
- (*) Blank screen from Oktopost #1806 - set languge in browser
- Speicfic url doesn't work - blank white browser #1598
- CTRL+Click on a link should open in new tab #1581
- Scroll up/down is not working with shield for some url #1269
- Pressing Shift+click should open a new window #1269 
- Restore browser service labels in scale

##[Staging:18.01-Build_249.3] - 2018-1-9
- (*) Full support for External proxy

## [Dev:Build_251] - 2018-1-9
- (*) New Docker Version 17.12 installed for new Dev installs
- Install new docker on deploy scripts #1785
- Admin UI sometimes doesn't display data #1725
- Impossible to show Perf-Window #1671
- zoom with ctrl+mouse #1662
- CTRL+Click on a link should open in new tab #1581
- When killing all consul-server containers the browsers and the shield_authproxy didn't started. #1538
- End to End test for Consul HA #1142
- Support "Find in page" CTRL+F #354

## [Dev:Build_250] - 2018-1-7
- when remove a node from the cluster it is not udpated at the consul #1754
- "External Proxy Password" is now a password field #1736 
- Default timeout waiting for sanitization is now 10 minutes (was 5 ) #1660
- Show CPU and Memory only if node is in the "Ready" state 
- Updated tooltips #1697 
- Updated Standby Remote Browsers Sessions tooltip #1768 
- Blacklist policy handling fixed using single watcher for #1572
- White mode indicator inside admin policy table. (details) #1733
- (*) Fix Broken Scale in Docker 17.09 (R2) #901 #1755 #895

## [Dev:Build_249.1] - 2018-1-7
- (*) Support 10K LDAP groups and LDAP groups with 10K users

## [Dev:Build_249] - 2018-1-4
- (*) Fixed broker crashing when using extProxySettings before it got a value from the Consul watcher

## [Dev:Build_248] - 2018-1-1
- Fixed logging on Consul error
- Use new scale logic by default 

## [Dev:Build_247] - 2018-1-1
- "no_votiro_payment" license flag should be "false" by default and it's meaning is: "has Votiro license" #1747
- Admin - Dashboard - fields in green area #1740 #1555
- Admin: when adding workers, the status remain Not Available, collector can't communicate with consul #1729
- Fix the tool tip for Standby Remote Browser Sessions #1726
- Dashboard - the display can misleads in case you have nodes without label browser #1724

## [Dev:Build_246] - 2017-12-31
- Fixed https issue with chrome

## [Dev:Build_245] - 2017-12-31
- Placeholder for "Standby Remote Browsers" #1555

## [Dev:Build_244] - 2017-12-28
- Admin UI Changes in Dashboard page #1702
- Complete support for extranl proxy with creds #1574
- Japanese Translation #1712

## [Dev:Build_243] - 2017-12-27
- Collector to sample resources every 15 seconds instead of 30
- (*) New logic for resource calculations, shich is now also "on" by default
- Ext proxy support disable mode properly

## [Dev:Build_242] - 2017-12-26
- Ext proxy force using parent ext proxy if defined
- Admin Dashboard updates #1555
- Updated labels for ext proxy auth settings

## [Dev:Build_241] - 2017-12-26
- Added ext proxy auth settings to Consul and Admin UI #1643
- CEF uses ext proxy if defined in Admin
- Updated tooltips #1555

## [Dev:Build_240] - 2017-12-25
- Added ext proxy auth settings to Consul and Admin UI #1643
- Ext proxy support passing auth param to other proxy
- Updated tooltip #1555
- Added background tab setting to Admin
- Fix for #1673

## [Dev:Build_239] - 2017-12-24
- (*) New Resource Computation #1577
- Provide shield-stats ton excat url only #1676

## [Dev:Build_238] - 2017-12-24
- Fixed CEF preload script errors
- Fixed leader selection after consul server set to 0
- Cleanup CEF logs

## [Dev:Build_237] - 2017-12-21
- (*) Fixed Printing #1668

## [Dev:Build_236] - 2017-12-20
- (*) updated fonts in CEF #1649
- (*) added Support for Zoom ( keyboard, mouse, browser) DPI settings

## [Dev:Build_235] - 2017-12-19
- (*) update setting to improve fonts
- Proxy and EXT is now alpine 3.7 # 1626
- Certificate settings in proxy update to fix IE issue #1625
- Background idle time settings should be ignored for download and for upload #1599
- ELK support for Overlay2 #1594
- Background tabs and idle improvements #1555 #1622

## [Dev:Build_234] - 2017-12-17
- Now using alpine 3.7 and new NodeJs

## [Dev:Build_233] - 2017-12-17
- Upgrade portainer to 1.15.5 
- HTTPS issue with specific url - https://www.israelweather.co.il/ #1614
- Link hover fixes #1542
- Fixed icap error
- Added Collector to yml

## [Dev:Build_232] - 2017-12-14
- Fixed Ext proxy setting 

## [Dev:Build_231] - 2017-12-14
- (*) idle tab reload screenshot blured and fade out #1555
- (*) Cache DNS queries #1112
- Reduce amount of logs #1584
- Changes for make HEAP size in elk dynamic
- Some containers don't wait for consul #1604
- Updated user agent version #1612
- Proxy auto detection - Web service can provide wpad.dat file #1610
- When adding nodes, prod version is installed #1508

## [Dev:Build_230] - 2017-12-12
- (*) Background tabs and idle improvements #1555 #1577

## [Dev:Build_229] - 2017-12-12
- File Download Behavior Change (per site and not file) #1570
- Firefox is get stuck when searching at google #1566
- Autoupdate from build 225 to 227 failed #1556
- Admin - Reports: iframe to take up all available space #1539
- Pop up dialog #1519
- Press on space on check box is not working #1498
- Down/up arrows are not working in drop down menu #1497
- Japanese issue on Mac #1465
- File Transfer - 'All' report should include uploaded files #1322
- Text Clipboard Copy/Paste Issue #1065
- Version is not updated after upgrade #981

## [Dev:Build_228] - 2017-12-11
- (*) kill idle background tabs #1555
- Pop up dialog #1519
- Pull down menu is cut #1484
- (*) Added support for HTTP Basic authentication #683 #426 #1389
- Upload info added to reports #1322

## [Dev:Build_227] - 2017-12-10
- Added proper computation for memory cluster - admin #1287
- Sometimes there is a problem to access the portainer #920
- Fixed ValidateKeytab() error prefix #1318
- Fix for outlook and web views #1526

## [Dev:Build_226] - 2017-12-07
- (*) Preformance upgrade #1510
- (*) Fixed download internal error 10 #1008 #1486 #1477 
- (*) AD errors are not clear #1318
- Update text message - profiles #1472
- Admin - add new profile is not sunc with the current state #1392
- Version is not updated after upgrade - removed log #981
- Shield Stats: UseHuman Readable time instead of timestamp #1433
- DNS Settings for Proxy should come from the host in the proxy #1378

## [Dev:Build_225] - 2017-12-05
- CPU usage improvment

## [Dev:Build_224] - 2017-12-05
- Fixed file upload #1483
- Focus input field after closing paste dialog #1459
- Improved texts for install script 

## [Dev:Build_223] - 2017-12-04
- Show node status (with labels) #1455
- Multi node - parameter for node name is not working #1447
- shield node script usage #1439
- Multi-machine: --certificate option doesnt work #1335
- Reports - change labels #1475
- Lift stuck alt key prevent some errors when closing CEF #1215
- Automated Admin test #1473
- Updated CDR components 

## [Dev:Build_221] - 2017-11-29
- Policies - default and override rules are applied only for profile 0 #1405
- Add new policy - default values #1365
- (*) Keyboard fixes #852
- (*) Need to allow to click on the message "The browser prevented opening a tab" to continue #1444
- (*) Open link without a popup warning #1457
- (*) Search in Online documentation does NOT work #939

## [Dev:Build_220] - 2017-11-29
- Updated AN in icap 

## [Dev:Build_219] - 2017-11-29
- Google Chat box - <return> does not send the text to the partner #1346
- Writing a document with Office Online behaves oddly #1239
- Sometimes ENTER, BACKSPACE and DELETE keys are not working #1215
- New keyboard code - Japanese keyboard #852
- Run/stop/restart errors due to docker/swarm errors #1415

## [Dev:Build_218] - 2017-11-28
- Fixed issue #1356 - admin behaviour when api is restarted
- Added header forwarding options to admin - settings page #1414
- Fixed #1398
- ELK use named volume changes
- Improved TestBindToAD() output #1318

## [Dev:Build_217] - 2017-11-27
- Admin - advanced authentication - when I get error, it shouldn't save the settings #1250
- Profile management at the admin need to be editable #1069
- Notification abot only one method of authentication is displayed when no need #1314
- Profiles are not deleted when I delete AD settings #1334

## [Dev:Build_216] - 2017-11-27
- (*) Clean ELK extra log #1410
- Missing Important Time Values in the Reports #1418

## [Dev:Build_215] - 2017-11-27
- Set log level of "LICENSE: license is expired at" to be fatal
- About window show wrong version #1301
## [Dev:Build_214] - 2017-11-26
- Write DC test results to log #1284
- Quality_idle_fps is set to 90 , like quality_lowFPS
- Add external syslog ability to logstash #1401
- Reports now have Selection box for quary duraion #1396 #895
- Authentication - primary DC address is not used when it on again #1384
- About window show wrong version #1301

## [Dev:Build_213] - 2017-11-23
- Quality settings in consul , detect if video is off-screen, superb quality updates when idle #1376
- Rendering engine 1.7.9 
- Prevent user agent helper from crashing squid #1387
- Several updates for installation script and multi node #1097 #1136 #1305 #1335 #1354 

## [Dev:Build_212] - 2017-11-22
- HigHJpgQuality #1376
- Added unit tests for policy matcher #1141
- Fixed #942
- Admin | Policies - align upper table with lower one#1104
- Added 2 CDR tests for archive password protected files where password contain special characters

## [Dev:Build_211] - 2017-11-21
- Fixed issue #1358
- (*) shield work on browser without cookie support #323 #1191
- Added automated tests for PAC file and Install Certificate pages #1213 

## [Dev:Build_210] - 2017-11-20
- (*) Fix jpg quality for video #1343
- (*) ELK Update to load faster #1339

## [Dev:Build_209] - 2017-11-19
- Fix for ELK bug

## [Dev:Build_208] - 2017-11-19
- squid policy acl in authproxy for white listed sites #1315 #1161 #221
- Updated reports #1064 #859
- Some logs are saved for longer times #1010
- Ctrl+x cut notification #1098
- Upload notification spinner #1323
- Configurable ttl for basic auth & policy matcher #1315 #1105
- Specific non-browser user-agents #221;helper concurrency
- Backup Configuration before Upgrade #1004

## [Dev:Build_207] - 2017-11-16
- Check user agent major AND name for browser #1202

## [Dev:Build_206] - 2017-11-16
- Typo: Explaination instead of Explanation #1292
- Change 'Add New Domain' to 'Add New Policy' #1280
- Change 'Advanced Authentication' to 'Authentication Settings' #1279
- Files and Sanitization - the text at the admin is not clear #1267
- Policy settings warning message is not clear when policies and profiles are not relevant anymore #1255

## [Dev:Build_205] - 2017-11-15
- When download file size is unknown, show a spinner
- Add 'username' column to all FileTransfer reports #1028
- Broker will check system load on every browser update
- Updated tooltip  #1268
- Drop down fix  #506 #891 #982
- Firefox keyboard copy bugfix #1150 
- Remvoe CSP response headers preload #1000

## [Dev:Build_204] - 2017-11-12
- Improve alive.html healthcheck #1242 #1229 
- Password reveal is now working for profile page
- Message when no ad is setup - create profile #1167
- Fixed modal error when saving invalid settings to profile page
- Logic fix for saving profiles. added support for warning messages #1169
- NTLM field added. #1165
- Added proper tooltip and placeholder according to #1180
- NTLM_fallback to be default true
- Edit profile #1069
- SPN update tooltip #1224
- ADtest also verifies kerberos #1180; fixed krb5.conf realm case

## [Dev:Build_203] - 2017-11-8
- NBC.com crash - CEF in half dead mode #1228
- Limit # of retries to get browser in AN #1230
- Decode user-agent from squid before parse #1226

## [Dev:Build_202] - 2017-11-7
- Fixed capitalization #1155 
- Filter apps in authproxy #1207
- Fixed Retrieving typo 	
- Fix docs url in Admin #1194
- Internal addresses always through second proxy

## [Dev:Build_201] - 2017-11-6
- Fixed capitalization #1155 
- Fixed icap-polices-module logger
- Fixed Broker typo 
- Install certificate - link to public instructions (#1176)
- NTLM don't send empty username
- Flag for ntlm fallback; no proxy user; no squid restarts

## [Dev:Build_200] - 2017-11-5
- (*) votiro settings updates# 1155
- Consul HA fixes #1132
- Policy Settings should be erased when I change the AD #1053
- User Profiles in Shield - notification on LDAP errors #1042
- Fix CTRL+A in JP #852

## [Dev:Build_199] - 2017-11-2
- (*) Fixed Problems with IE #1012

## [Dev:Build_198] - 2017-11-2
- Last uploaded info for pacfile #937
- Set forward headers properly &settings #1078
- Added and rearranged Votiro settings in Admin UI  #1100 #1090
- Fixed admin login on multi-node #911
- Changed defualt file upload/download size to 100MB (was 10MB)
- Moved CDR components log level settings under the "Logs" #1090

## [Dev:Build_197] - 2017-11-1
- Write to the report the sanitization task in case the user has canceled the file's password dialog 
- Re-implemented zip password protected testing by node-7z package - #1075
- Browser scale parallelism incresed to 8 

## [Dev:Build_196] - 2017-11-1
- Fix Admin - Profiles better spacing #1023
- File upload bug - Japanese filename #1026
- Added tooltips for Profiles - #1093 
- Added instant upload for pac file. Message updated #1029 
- Clean previous added values - add profile dialog #1092
- File upload bug - Japanese filename #1026
- policy name for password archive is hardcoded #1079
- added proper icon for profile  #1093
- added message field for basic authentication - profiles
- updated default proxy messages - Please enter your organisation 
- CDR fixes  #1077 #1084 #1076 #1081 #1083
- Url policies need to be removed once it's profile has been removed #1070
- Clean previous added values - add profile dialog #1092

## [Dev:Build_195] - 2017-10-31
- Fix ctrl+x #914 #1086 
- Fix debug panel #1051 

## [Dev:Build_194] - 2017-10-31
- Proxy message translation #1042 
- (*) Settings page reorganization #1029 

## [Dev:Build_193] - 2017-10-31
- (*) Admin UI - Red MessageBox "user action status of undefined " #1050
- (*) Allow as_address in authproxy conf #1067
- DC reslove will add to etc/hosts if bind fail #1044 
- Fixed modal dialog add profile button #1054
- Clean ldap_cache in case the usage of AD was changed #1042
- Change upload notification  #1034 
- Updates to yml file for better logging 

## [Dev:Build_192] - 2017-10-30
- Added username into dashboard browsers list #1018
- Admin Dashboard - Remove Services section #931
- Added comment property to policies. removed auto column #887
- Search active directory placeholder added
- Remove internal squid whitelist #1042
- Ssanitize password protected archive files only if needed (Votiro settings) - #638 
- Fixed the case where trying to sanitize an archive file against Votiro cloud server
- Build 190 Advanced authentication is not working #1040
- Checking if archive file is password protected and if password i correct by using 'unzipper' #638

## [Dev:Build_191] - 2017-10-29
- (*) Fixed CEF crash 

## [Dev:Build_190] - 2017-10-29
- (*) Updated Admin #989

## [Dev:Build_189] - 2017-10-29
- (*) CDR support for Password Protected Files #638

## [Dev:Build_188] - 2017-10-29
- (*) Support for file upload #350

## [Dev:Build_187] - 2017-10-26
- Remote Browser support for profiles in polices
- Fixed default Pac file

## [Dev:Build_186] - 2017-10-26
- First version that suppoer user authetication and profiles #900 #831 and #989
- Added Admin UI for Pac file #937
- Bug fix when zoom #960 #961
- Internal network subnet is now 10.20.0.0/16
 
## [17.42-Build:185] - 2017-10-23
- UI for IE mode
- new keyboard code - Japanese keyboard #852

## [17.42-Build:184] - 2017-10-22
- white warning text modification #956
- Admin Reports Advanced Button (R4) #840
- System settings backup #953
- HA for shield components: Consul #924
- Issue with Search from Resolv.conf #968

## [17.41-Build:183] - 2017-10-19
- Fixed White urls Major flickering #969
- Fixed proxy crach #955

## [17.41-Build:182] - 2017-10-16
- Fixed systemId bug #888
- Fixed documnation link #885
- Basic support for IE #819
- Basic support for proxy auth 

## [17.41-Build:181] - 2017-10-15
- New keybaord code
- ELK now work on Debian 
- Installing Docker Version 17.06 (Upgrade/Downgrade if version is different)
- first version of Auth Proxy and shield-maintenance continers

## [17.39-Build:180] - 2017-10-2
- File download and sanitiztion updates #842
- Fixed missing version in about dialogs for admin #590
- Fixed admin disconnect issue
- Updated default white list , removed web.whatsapp.com and added shielddocs
- CDR bug fixes #690 #776 
- Fixed for issues #589 #855
- Adding Flag to Restart the system during upgrade
- Added EULA during installation #874
- Fixed file not found issue during installation 
- Web Service generate PAC file based on shield IP #837

## [17.39-Build:179] - 2017-09-28
- Fixed missing version in about dialogs for admin #590
- Using newer portainer:1.14.2
- Auto-Calculated System Capacity #668
- Implement a workaround for #855 (DNS issue)

## [17.39-Build:178] - 2017-09-26
- Fixed docs path for install certificate
- Tab order for licensing #691
- Dashboard refresh for every 5 seconds #787 
- Logger module doesn't include component and log-level - Fixed #690 
- Download a file - notification for small files can barely seen - Fixed #776

## [17.39-Build:176] - 2017-09-26
- CDR UI - #839 - domain instead of URL in admin strings policies
- Fixes for #785 and #640 - cdr related changes
- Fix update consul system-id from secret #686
- Use settings from host's /etc/resolv.conf for DNS resolver in proxy-server

## [17.39-Build:175] - 2017-09-25
- Working with HAPI server in "stream" payload mode for better preformance
- Admin loading time on the first usage #712
- Removed the URL validation in admin/policies #788
- Reordered report columns #644
- (*) Re-structured download/sanitization reports #755
- (*) Fixed file appears twice at the sanitized report #806
- (*) Fixed report errorMessage and errorStep fields #644

## [17.38-Build:174] - 2017-09-18
- fixes for web service (logs, code fixes, default PAC file)
- (*) Downloading notification with loading indicator #792


## [17.38-Build:173] - 2017-09-18
- **(*) New system defaults - system_capacity 40, with min_available_pool 20 **
- Log cleanup for ICAP, Broker and CEF
- send all AltGr combinations as unicode - fix for @ key #783
- Admin reports run button refreshes the iframe  #772
- Added more built-in reports #781 #780 #761 #735      
- **(*) Support non-english file name download  #710 **
- Removed pool section from shield-stats
- Handle case of file download with 0 size  #784 #774
- **(*) Added web service component to provide certificate and PAC file #782**


## [17.37-Build:172] - 2017-09-14
- Broker scale bug is fixed 

## [17.37-Build:171] - 2017-09-14
- all notifications in a single dialog #671 
- Admin pool settings messages #539
- Remote Browser log error and stack trace on uncaughtException
- Fixed refresh page on 1006 ws abnormal disconnect

## [17.37-Build:170] - 2017-09-14
- Fixed broker log levels
- Admin dashboard show licenses in use

## [17.37-Build:169] - 2017-09-14
- Licenses in use is now counting the real users #729
- Change idle disconnect message #718 
- Remove printjs dep. fix printing #753 
- updating text according to #750
- Integrate Votiro new eval subscription key Updated default settings (some are hardcoded..) #631 

## [17.37-Build:168] - 2017-09-13
- Nicer message of activation fail with bad key
- (*) Updating Admin text according to #750
- (*) Admin reports links fixed #725
- (*) Fix for idle timeout changing to 16 on upgrade 
- (*) Remove Allow Recurring Attempts Bypass (Must be NO in Production #751
- (*) Fixed context menu Text (capital letters)
- (*) context menu section changes #355
- (*) Publish shield internal pages on real url #743

## [17.37-Build:167] - 2017-09-13
- Several bug fixes for CDR
- New strings for the download/sanitization messages (#748)

## [17.37-Build:166] - 2017-09-12
- Better Context Menu

## [17.37-Build:165] - 2017-09-12
- Activation: Improve messages
- (*) Fixed Override policy (#681)
- (*) Admin Report fixes (#706 #725)
- (*) Fix downloads with # in filename (#719)

## [17.37-Build:164] - 2017-09-12
- Remote Browser: Exit on Crash
- (*) download policy should be SANITIZE by default (#723)
- (*) Settings are upgraded when needed (#727)
- (*) Fix crach when pausing media
- (*) consul UI is password protected (#706)
 
## [17.37-Build:163] - 2017-09-11
### Changed
- (*) Automatic Rules Addition disabled
- Soak Tests (4h, more than 4000 URLs)
- (*) Protect ELK and Consul UIs with password (#706)

## [17.37-Build:162] - 2017-09-10
### Changed
- Include disable of auto role of un-used urls update Admin

## [17.37-Build:161] - 2017-09-10
### Changed
- (*) New Logic for Apps based on User Agent #667 - (!) please clear automatic rules on upgrade 
- Shield-Proxy should handle a case of ICAP address changing #679
- Updated context menu #355
- CEF re-register - should help with missing browsers #704 #338 #635
- Admin updates (Activation information should be updated once activated #625, Show licenses in use in dashboard, #687, #603)
- (*) File Cleaner (#682, #701)
- (*) Integration with Votiro (Cloud for Eval)
- Installer script code-cleaning
- Installer - "no more space" issue #570 (shield branch) 
- Deployment: Pac file + instruction is ready for QA and Doc #559

## [17.36-Build:160] - 2017-09-10
### Changed
- File Cleaner: Enforce Votiro license			
- Admin: Support email to about screen #687 update tooltips according #621

## [17.36-Build:159] - 2017-09-10
### Changed
- Admin update tooltip according #603 - search tooltip admin policies update tooltips according #621 

## [17.35-Build:155] - 2017-09-27
### Changed
- Moved to Prod on:  - 2017-08-29
