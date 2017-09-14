# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).
- Git Issues should be referenced by #
- Main Features/Bug Fixes should have (*)
- User Action Required should have (!)

## [Unreleased]

## [17.37-Build:172] - 2017-09-14
- (*) Broker scale bug is fixed 

## [17.37-Build:171] - 2017-09-14
- all notifications in a single dialog #671 
- Admin pool settings messages #539
- (*) Remote Browser log error and stack trace on uncaughtException
- (*) Fixed refresh page on 1006 ws abnormal disconnect

## [17.37-Build:170] - 2017-09-14
- fixed broker log levels
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
