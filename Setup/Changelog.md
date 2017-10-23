# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).
- Git Issues should be referenced by #
- Main Features/Bug Fixes should have (*)
- User Action Required should have (!)

## [Unreleased]

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
