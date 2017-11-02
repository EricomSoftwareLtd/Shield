# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).
- Git Issues should be referenced by #
- Main Features/Bug Fixes should have (*)
- User Action Required should have (!)

## [Unreleased]

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
