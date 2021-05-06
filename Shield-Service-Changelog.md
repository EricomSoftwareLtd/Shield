# Changelog for Shield Service

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

- Git Issues should be referenced by #
- Main Features/Bug Fixes should have (*)
- User Action Required should have (!)

## [Unreleased] - don't remove this line, used in CI

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
