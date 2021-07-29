# Changelog for Shield Service

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

- Git Issues should be referenced by #
- Main Features/Bug Fixes should have (*)
- User Action Required should have (!)

## [Unreleased] - don't remove this line, used in CI


## [Rel-21.06.776] - 2021-07-31

### New Features

- Analyze Domain/URL from Admin (Service Section)

### Enhancements

- Add AV Blocked to Risk Summary Report
- CDR SASA Block Message Reason added to report and end-user message
- Print Protected Policy: generated PDFs by Shield are sanitized
- Page for clearing Shield cookies/localstorage/cache http://shield-stat

### Bug Fixes

- Fixed: Ctrl+C is not working properly on Shield Cloud (CA0000075929/QA#826417)
- Fixed: About security when the application is Allow by default (CA0000075993/QA#826893) 
- Fixed: White sessions - main page is not displayed when allow resources = No
- Fixed: Gmail attachment does not fully load in Shield
- Fixed: Categories are not exported when exporting policies via the Admin UI 
- Fixed: Copy-and-paste problem with Crystal rendering (CA0000075004/QA#819860)
- Fixed: Opening PDF from gmail shows incomplete document
- Fixed: Screens not rendering well in Relativity app
- Fixed: Smart-read only needs to support MFA (PIN entry) 

## [Dev:776.1] - 2021-07-04 => Dev

- SHIELD-9953 - Macys does not work on white

## [Dev:776] - 2021-06-29 => Dev

- SHIELD-9702 - Add User Location on Google URLs (re-enabled)
- SHIELD-9915 - Cant import a policy with access Allow, No SSL Bump
- SHIELD-9871 - Cant open gmail.com when Override Geolocation enabled 
- 




## [Rel-21.06.776] - 2021-06-29

### New Features

- New Labels for Policy Access: Allow/Deny (SHIELD-9655)
- Suspected Sites (URL) Detection in Allow mode (SHIELD-9832)
- New Access Option: 'Allow no SSL Bump'
- Add User Location on Google URLs (Google/YouTube) (SHIELD-9702)
- Limitation: 'Anti virus' is not supported in 'Allow [no ssl bump]' (SHIELD-9906)

### Enhancements

- Additional License option for Tenant (Targeted Isolation)
- New Partner in Tenant Settings (NS)
- When printing is disabled, display a notification when a user tries to print (SHIELD-9393)

### Bug Fixes

- Fixed: Security - Cookies are editable and not immutable (SHIELD-9810)
- Fixed: Blocked Upload Report does not show correct Site (SHIELD-9809/CI-13)
- Fixed: The option to open Zoom as native doesnt exist with shield (SHIELD-9658)
- Fixed: Shield loads blank page (edreams) (SHIELD-9736)
- Fixed: App is missing from the applications report (SHIELD-9812)

## [Rel-21.06.769] - 2021-06-13

### New Features

- Support List of Users for Admin (Cloud-admin and Tenant-Admin) 
- Support Role Based Access Admin (Cloud-admin and Tenant-Admin)
- New Format for all Squid Error Pages 

### Enhancements

- Hardened Tenant-Proxy
- Block Applications from Tenant Proxy

### Bug Fixes

- Fixed: Export to CSV (reports) with non English Characters
- Fixed: Gmail ending up out of Shield

## [Rel-21.04.764] - 2021-05-26

- New Format for Blocked Pages and Malware

## [Rel-21.04.762] - 2021-05-09

### New Features

- Smart Read-Only - Social media site in read only beside Login page & search
- Log Shipping Output Enhancements (Elasticsearch,HTTP,S3,Splunk,Syslog)
- Suspicious Site Enhancements
  - New Phishing Feed (ZTEdge)
  - Suspected Sites Report
  - Enable Category  (NetSTAR) per Tenant
- Client-Side Certificate Support
- Admin-API (Beta)

### Enhancements

- Policy for Japanese domain name (CA0000074113/QA#813428) 
- Changes to the report view (CA0000073403/QA#808653)
- Whitelisted should be sent to syslog (CA0000074132/QA#813050)
 
### Bug Fixes

- Fixed: Queens Medical - when Yahoo Captcha appears, user is unable to login to yahoo mail
- Fixed: Media playback not muted (and plays full volume) 
- Fixed: playing video in whatsapp web not working 
- Fixed: Not possible to mark text correctly (CA0000072616/QA#803399)
- Fixed: Shield Cloud with Cisco Umbrella 
- Fixed: Proxyless mode allows to run site in white mode

## [Rel-21.03.746] - 2021-03-21

### New Features

- Admin UI for Log Shipping (Elasticsearch, Splunk, S3)
- New Phishing feed from ZTE
- White labeling Tenant Admin per subdomain

### Bug Fixes

- Fixed: Sync local storage client<->Remote Browser (whatspApp web QR code)
- Fixed: whatsapp web + slack web typing cursor placement
- Fixed: Media playback not muted (and plays full volume)
- Fixed: Gmail is getting stuck
- Fixed: Shield SAML response has extra ? character
- Fixed: <https://www.jal.co.jp/jp/ja/> stuck and slow

## [Rel-21.02.732] - 2021-02-14

### New Features

- CDR System per Tenant
- Allow Direct File Downloads for large files
- Various Security Enhancements

### Bug Fixes

- Fixed: Several Bug Fixes for Crystal
- Fixed: Trailing :443 causes the proxyless redirection to fail 
- Fixed: File Transfer - Downloads reports is not working
- Fixed: Error Access Denied when trying to browse with new proxy without clearing cache 
- Fixed: <www.pgcasa.it> not displayed in Crystal mode 
- Fixed: Several display / crystal issues with tg24.sky.it 
- Fixed: Shield fails to display PDF from <strauss-water.com>
- Fixed: SAML SSO - return on POST works only if IP address is specified

## [Rel-21.01.721] - 2021-01-31

### New Features/Enhancements:

- Upgrade Underlying Rendering Engine
- Bug Fixes for Crystal
- Improved Frame Mode Scrolling and Typing User Experience
- Adjust Session Time Zone based on Local Browser
- Visual Indicator Darker and thicker
- Removed Flash Support (as per flashplayer/end-of-life)
- Few Korean Bug Fixes
- Various Security Enhancements
-   Hardened Remote Browser
-   Sanitization of SVG and CSS in Crystal Mode
-   Updated jQuery
- Display Source IP in the Access Denied message
- Enhancements and Bug Fixes on Audit in Admin

### Bug Fixes:
- Fixed: File upload indicator missing 
- Fixed: Page Jumps without user input
- Fixed: store.ferrari.com in Crystal issues 
- Fixed: Bad PDF rendering 
- Fixed: errors in file downloads
