# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).
- Git Issues should be referenced by #
- Main Features/Bug Fixes should have (*)
- User Action Required should have (!)

## [Unreleased]

## [Dev:Build_391] - 2018-08-21
- Sometimes ELK container stack on create indexes stage and not continue #3988
- (*) Copy/Paste Images to/from Shield #490
- totalsource.adp.com view payroll report authorization error #3919
- problem to view PDF with shield #3068

## [Dev:Build_390] - 2018-08-21
- Custom protocol links support https://blog.rankingbyseo.com/ #3911 
- iFrame with PDF source not rendered and crash Electron #2496
- Added logs when admin fail to parse translation file 
- status -s doesn't work #3927
- Cross Window - bank Leumi - bll.co.il export to PDF #459 
- Unable to launch local Excel from online excel (SharePoint) #3256

## [Dev:Build_389] - 2018-08-19
- pac file fix minor typo #3854
- Fonts issue - the space between the letters should be imporved #3938
- Fonts issue 3: the fonts with shiled have diff color, and it looks bolder #3696
- Fix Missing Fonts Issues #3640
- Check Chinese Websites #3351
- Cross Window - bank Leumi - bll.co.il #459
- error is not being displayed for some web sites in case creds are wrong #3937
- sandblast activation key has changed please update the internal license #3819
- Support certificate chain #2247
- Show the notification dialog until AccessNow completes downloading the file (#3679)
- reported by Eran - twitch.tv fullscreen message is not visible enough #3795
- "Failed contacting Sanitization Server" alert doesn't show the error #3888
- Squid logs size needs to be limited #3896
- Error while saving Japanese translations #3856
- Align log levels in admin with bunyan #3917
- Admin login using LDAP #3683
- Missing Important Time Values in the Reports #1418
- LDAP admin login - fix the error when insert bad credentials #3782
- LDAP admin login - no clear errors of authentication failures #3787
- LDAP admin login - Access not permitted when using down level login name #3785
- if the user is locked I get a message that the credentials are invalid #3932
- Auth proxy helper to give a better error if AD user is invalid #2132
- collector and other components errors - at the dashboard cpu memory etc are NA #3675
- Slow connection alert #2378
- issues with update process- bad erros and docker upgrade fails #3663
- Consul upgrade + configuration tuning #3746
- Consul error logs not arrive to ELK. #3949
- Updated Japanese translations and deleted duplicated keys

## [Dev:Build_388] - 2018-08-12
- Sometimes some of the components do not funcation #3831
- Collector and other components errors - at the dashboard cpu memory etc are NA #3675

## [Dev:Build_387] - 2018-08-09
- Leumi.co.il popup issue #3866
- LDAP login admin - no tool tip #3901
- Fixed wrong log level for Remote Browser 

## [Dev:Build_386] - 2018-08-08
- Default app rule for clientsN.google.com #3893
- Remove debug flag of negotiate_wrapper_auth
- Two factor authentication support #3871
- (*) addnodes failed because no sshkey #3886
- change cross window fake url from google.com #3905
- wait for both cookies and adblock dns on requests 

## [Dev:Build_385] - 2018-08-07
- (*) Timeout occur during join new node to cluster #3840
- (*) can't login to the poratiner in some machines #3877
- Broken Websites #3641
- Allow navigation to sites in adblock lists #3799
- Failed to load properly error - DNS adblock #3089
- Notify end user when page load is slow (18.06) #3011

## [Dev:Build_384] - 2018-08-07
- Certain scribed URL takes a long time to load (sometime after 30 to 60 seconds and sometimes it did NOT load at all after few minutes) #3842

## [Dev:Build_383] - 2018-08-06
- Patch for Timeout occur during join new node to cluster #3840

## [Dev:Build_382] - 2018-08-05
- Japanese Strings for 18.08 (from KKA)

## [Dev:Build_381] - 2018-08-02
- BTL: Disk on Management Nodes is fills up very quickly #3804
- Limit Logs for ELK 
- Loaded dictionary for locale us-en Error #3833

## [Dev:Build_380] - 2018-08-02
- Route all traffic (including white-listed) via the Browser farm #3654
- After adding nodes all confiugration is lost #3813
- Votiro: Include Votiro dynamic information reason (untranslated) in the tooltip #3837
- Backup are not generated sometimes #3844
- Certain scribed URL takes a long time to load
- Dropdown issue #3797
- [[Investigation]] QA#687503 It is strange to print PDF #110

## [Dev:Build_379] - 2018-08-01
- Incorrect node join to cluster block addnode script operation #3825
- The file is being download but also I get an error #3794
- Add error for the user in case some or all files inside a zip file is being blocked #3808
- When download virus inside a zip protected with password the message is incorrect #3809
- Route all traffic (including white-listed) via the Browser farm #3654
- Fix download docker images on slave nodes
- After adding nodes all confiugration is lost #3813
## [Dev:Build_378] - 2018-7-30
- smaller adblock list
## [Dev:Build_377] - 2018-7-30
- All connections reports shows only urls in white mode #3761
- Connections report - no results #3727
- KKA - have records also for white urls #3587
- CDR to support UpStream Proxy #3571
- Notifiy end user when page load is slow (18.06) #3011

## [Dev:Build_376] - 2018-7-26
- Broken Websites: Fix iframe msg & video issues #3641 #3743 #3764 
- Remote Browser: Right Click Menu Change Text #3702
- Bypass upstream proxy for CDR #3571
## [Dev:Build_375] - 2018-7-24
- Default for XFF should be Forward, not set #3763
- Portainer Agent to see all containers #3739

## [Dev:Build_374] - 2018-7-19
- Add option to block sites with bad certificate #3720
- Change Right Click Text #3702
- When download file with and without sanitization wait for AN to download to end user #3679
- CDR: Consider showing file block reason to the user, based on the report #1360
- Fixed force.com and myspace.com, remove old list of sites to block from proxy
- Admin login using LDAP #3683

## [Dev:Build_373] - 2018-7-17
- Fix auth proxy crash on LDAP refresh in Admin

## [Dev:Build_372] - 2018-7-16
- Notifiy end user when page load is slow (18.06) #3011
- Several components updates
- http://tumblr.com/ - Appstore icon does work - AD block #3710
- Use an image with newer openjdk version for ELK (#3621)
- XFF and Client-IP to be forward by default #3708

## [Dev:Build_371] - 2018-7-15
- internal error 3 on pending when using sandblast #3656
- Technical items raised by Snir from Check Point during SandBlast integration demo #3650
- Error Report Per Error Level #3476
- unbound and squid fail ttl #3689
- update continue even if pre check fails #3651
- problem to run update on a machine with upstream proxy #3633
- White list urls should be logged in ELK #3355

## [Dev:Build_370] - 2018-7-11
- 'Browser' option for application rules #3557
- Slow Network Notification #3676
- Bluecoat firewall cause all urls to be considered as app, hence all are white apps #3557
- updated comments and messages (#3606)
- Support upload to iFrames #3629
- White list urls should be logged in ELK #3355
- update continue even if pre check fails #3651

## [Dev:Build_369] - 2018-7-8
- Limit System Capacity according to CPU #3601
- Fixed en-us tooltips for CDR #3612
- Verify certificate is a ca certificate #3477
- Notification about validation success for password certificate is displayed over again when save #3581
- Activation message #3559
- Export - values are not correct for suspend #3536
- Add the file name and extension to the download and upload notification #3519
- Settings - custom CA password #3499
- Remote apps profiles from the application profile list #3411
- Translations - user language change also admin language #3468
- Shield Admin - unique values in profile names #3333
- Error Report Per Error Level #3476
- Addnode one manager failed without any error #3607
- Typos on addnodes.sh #3606
- when switch from single to multi node need to run restart and not reload #3431

## [Dev:Build_368] - 2018-7-8
- (*) Fixed localbrowser stuck after running long time in background #3077 #3657 #3625
- Updated jp lang translation 
- Updated Remote Browser to support Upstream proxy #3571
- NTLM is off by default  #3626
- KKA - Character conversion problem with function key f6 in chrome #3610
- KKA - [[Question]] QA#688697 About combination key #118 #2874
- KKA -[[Input Issue]] QA#688638: Undefined Japanese conversion character is deleted on IE #119 #2872
- typing in Japanese issue 2 #3302

## [Dev:Build_367] - 2018-7-4
- Restart shield if required according to #UNR flag in shield-version (new) #3598
- fix shift+0 in alphanumeric Japanese #2874

## [Dev:Build_366] - 2018-7-3
- Fix fms positioning and reconnect issues #3625 #3619
- KKA - Character conversion problem with function key f6 in chrome #3610

## [Dev:Build_365] - 2018-7-2
- Default ntlm fallback set to false. removed --verbose
- Japanese press escape while in composition mode makes copies of text
- Japanese key combinations: space after shift+kanji #2874

## [Dev:Build_364] - 2018-6-28
- drop-down values do not work properly #3543 1.8.7 
- status doesnt work #3572
- Collector test scripts (on-demand, periodic) to support UpStream Proxy #3573 KKA #130

## [Dev:Build_363] - 2018-6-27
- KKA - [[Input Issue]] QA#687279: Japanese character conversion candidate display position #109 #3170
- need to click on the screen so last char will be reflected #3555
- ericomshield-setup.sh install different docker version #3568
- ericomshield-setup.sh not create ericomshield-updater.service and not run service #3566
- Document Setting US Proxy on Shield #3527

## [Dev:Build_362] - 2018-6-26
- Import does not work at all #3554
- Docker Installation w/o internet #3377
- KKA - [[BUG]] QA#691149 It does not work in the environment where the upstream proxy exists #130 #3244


## [Dev:Build_361] - 2018-6-25
- .autoupdate was removed during autoupdate #3532
- KKA - bug with typing #3386
- X-Forwarded-For forwarding in https #3546
- admin | policies | import - failure file #3458
- admin UI - export and import policies - the values should be converted from codes to text #3441
- policies/applications table - scroll bar - edit row #3366
- can't import rule when I change suspend to be 2 or 3 #3449
- ignored_shield_policies file #3472


## [Dev:Build_360] - 2018-6-24
- Admin UI - export and import policies - the values should beconverted from codes to text #3441
- Import / export - when using ignore the urls should be added to the bottom #3466
- Admin | policies | import - failure file #3458
- Remove the tool tip for Profile #3442
- Disable "underline" fix to be like 18.05 #3515
- Pre-install check (before docker install)
- Enable cookies and allow_direct_ip_address by default #3510
- Docker Installation w/o internet #3377


## [Dev:Build_359] - 2018-6-20
- CPSB - key #3498
- Netdata is taking a lot of resources #3419
- Improve Alert Mechanism on Service Global #3469
- shield stats shows not healthy #3491
- remove the alert about netdata #3482
- pre check install - 1029-internet-speed.sh failed to be executed #3485
- admin | policies | import (dialog) #3461
- admin | policies | add new policy #3457
- remove the tool tip for Profile #3442
- Admin | settings | SSL - missing tooltip #3416
- AdBlock - string change #3383
- admin - profiles - change icon color #3414
- no error message when the file cannot be download and tab is at background #2038
- CDR: Consider showing file block reason to the user, based on the report #1360
- admin UI policies - export/ import - the table is not working for editing #3429


## [Dev:Build_358] - 2018-6-19
- (*) Redcue contierns size 
- (*) Removed Ericom.com and google.com from connectivity tests
- Installer/Upgrader should support -list-versions (R4) #537
- no error message when the file cannot be download and tab is at background #2038
- problem to watch videos on facebook #2763
- Alert on email Improvements #3270
- admin | policies | import - failure file #3458
- auto_generated - please remove completely from code #3455
- no error/warning msg for the user in case import fails #3452
- admin UI export policies table - fix the order of the columns #3435
- Alert "Failed contacting Sanitization server" to include the CDR URL(s) #3422
- Netdata is taking a lot of resources #3419
- policies import warning message - the download should be enabled #3450
- admin UI - tool tip for export and import should be fixed #3440


## [Dev:Build_357] - 2018-6-14
- Set Trust all for XFF Forwarding #3395
- AdBlock - string change #3383
- (*) Youtube is getting stuck #3077
- Added AV to sandblast , Fixed notification timeout
- Fixed test alert text for Slack #3403
- Basic auth password is saved as base64 
- Apply host Timezone during update

## [Dev:Build_356] - 2018-6-12
- kaytana website dropbox is not visible #3372
- Policies table - comment column #3315
- Adblock - does not work as expected #3290
- Alert on email Improvements #3270
- Copy doesn't work when copying via a "Copy Code" link (reported by BTL) #2725
- Admin - default language in translations #3297
- add a message to refresh after changing the default langauge #3275
- Context menu allow user to select UI language and store in local browser #3182
- Drive speed test - syntax error #2764
- Support for shield to use Customer CA with password #2756
- localisation support for end user texts (context menu) #2587

## [Dev:Build_355] - 2018-6-12
- localized context menu is off #3348
- Data retention for basic authentication #3347
- Movies - security session time out #3344
- Sandblast - can't download files with foreign language #3339
- AdminUI: Application Table is broken #3335
- Policies table - comment column #3315
- End user localisation V2 #3307
- Elk service is unavailable after restart #3286
- Clean docker images/containers in Maintenance docker #3267
- stopped containers and volumes - not cleaned properly #3211
- Applications Report - column re-order #3139
- Admin - suspend tabs value other than "Both" #3110
- Health-Check point for Shield #2962
- Consul restore.sh should work with full file path. #2826
- ELK - Old data/schema conflicts #2825

## [Dev:Build_354] - 2018-6-10
- Admin main menu #3196
- Notifications report - syntax mistakes #3056
- Fixed collector failed to contact ELK

## [Dev:Build_353] - 2018-6-10
- Use Ad Blocking Protection - remove from settings #3291
- http://shield-perf/ - bigger url field #3213
- Context menu allow user to select UI language and store in local browser #3182
- Align different timeouts and their outcome (terminate and absolute timeouts) #3115
- Copy doesn't work when copying via a "Copy Code" link (reported by BTL) #2725
- Drive speed test - syntax error #2764
- Admin - support additional CDR solutions #3148
- Fix tool tip for other vendors then votiro #3288

## [Dev:Build_352] - 2018-6-7
- (*) Support for shield to use Customer CA with password #2756
- Add System Name to Shield Stat #3272
- Uploading a file too big fails with Internal error #2832
- Upload big file is failing #2810
- Alert on Email Improvements #3270

## [Dev:Build_351] - 2018-6-6
- admin UI is not functioning #3278
- update.sh fails #3281
- KKA - [[Input Issue]] QA#687132 repeated with TAB #108 #3171
- Pre check needs to check if bind9 is installed #2971
- KKA -[[Input Issue]] QA#688638: Undefined Japanese conversion character is deleted #119 #2872
- Set remoteBroswer path to use shm #3231

## [Dev:Build_350] - 2018-6-5
- adBlocker end-user message - change text #3224
- esbranch is not being updated with the correct branch #3214
- Ova build 18.05 - remove one of the DNS components #3194
- Sanitization failed - internal error 3 #3188
- Support AD block in policies #3173
- KKA - [[Input Issue]] QA#687279: Japanese character conversion candidate display position #109 #3170
- Update.sh not execute docker version update on worker node. #3164
- Admin - support additional CDR solutions #3148
- Support sandblast for file sanitisation #3144
- Update and autoupdate should update sysctl config #2791
- Output when running update.sh is ugly #2420
- Limit the Amount of Tabs a User Can Open #1005

## [Dev:Build_349] - 2018-6-3
- Checking distribution pre-install test fails on my machine with "Internal Error" #2922
- Pre-check to support upstream proxy #3054
- Sync shield server time #3091
- Admin UI -is partially broken see issues at settings and alert section #3177
- Missing information about machine #3219

## [Dev:Build_348] - 2018-5-31
- admin UI -is partially broken see issues at settings and alert section #3177
- Add New Application dialog #3151
- Admin-Applications - skip authentication #3097
- Apps support in Shield #1525
- Fixed collctor 

## [Dev:Build_347] - 2018-5-31
- Failed to update the cluster with current build #3221
- ./showversion is looking different after create sshkey #3180
- Admin - translations - several issues #3174
- copy is not working on some web sites #3154
- addnode.sh fails when using US proxy #2930

## [Dev:Build_346] - 2018-5-28
- Pre-check to support upstream proxy #3054
- Added dns white list url - fix ynet movies
- File Download (with sanitization) load test issues (reported by KKA) #3133
- New version of sshkey
- Added Ext Proxy non Adblock mode 
- Ctrl+C is not working + fix for capital letters 3189
- pre-install-check doesnt work with US proxy #2951
- pretest - check it is an amd64 install #3129

## [Dev:Build_345] - 2018-5-28
- Admin - policies - stream #3040
- f3 for searching at the browser is not working #2987
- Youtube play in "0.5 speed" option ignored (reported by Ilan) #2952
- Electron 2.0 #2900
- Booking.com - cannot view map #2765
- "Copy to clipboard" function on AWS Console - does not work #2644
- CTRL+F does not work on edge #2543
- back arrow is not working when using different domains -After other p1 #1524
- Localization support for end user texts (context menu) #2587
- When a service is not starting add "more details" #2786
- No way to see that keytab was uploaded #2739
- Copy doesn't work when copying via a "Copy Code" link (reported by BTL) #2725
- [[Bug]]QA#688618: Shift key is keeping pressed issue with Roman input mode #116 #2876
- KKA - [[Question]] QA#688697 About combination key #118 #2874
- KKA -[[Input Issue]] QA#688638: Undefined Japanese conversion character is deleted #119 #2872
- kka - QA#689263: There is a problem with the operation of the "Henkan" key (conversion key). #122 #2867
- can't type ä, ü, ö special characters in shield using FF #2807
- Doc - limitation KKA ーUnderline of unconverted character string #87 #2381
- Japanese - alt+kana roman key type the current mode on IE and Edge #2368


## [Staging:18.05-Build_344] - 2018-5-24
- After Idle Timeout: Reload on click anywhere in the page (icap)
- Update bug fixes (autoupdate)
- dnsrr in yml for the dispatcher
- Fix raise condition on creating CA certificate (Admin)

## [Staging:18.05-Staging:Build_343] - 2018-5-24
- Fix setting upstream proxy on change
- DNS tests should work via the correct DNS #2973
- Jp admin translation fixes
- Fix docker version output when run shield #3072
- Fix child windows offscreen crash #3058
- Increased test timeout to 3 minutes (instead of 2)
- Disabled Capacity alert 
- Change tunnel error msg #3089

## [Dev:Build_343] - 2018-5-23
- Fix setting upstream proxy on change
- CDR automated tests Improvements #3108
- DNS tests should work via the correct DNS #2973
- Jp admin translation fixes
- Fix docker version output when run shield #3072
- Fix child windows offscreen crash #3058
- Increased test timeout to 3 minutes (instead of 2)

## [Dev:Build_341] - 2018-5-22
- Disabled Capacity alert 
- Change tunnel error msg #3089

## [Dev:Build_340] - 2018-5-21
- Shield Stats improvements #3080
- DNS adblock whitelist #3089
- Add averageCpuCorePerSession & averageMemoryPerSession to uploaded shield stats #2997
- Slow connection alert #2378
- Install uuidgen in the install #3081

## [Dev:Build_339] - 2018-5-17
- Apps support in Shield #1525
- Applications -default and override rules do not support multi profile #2937
- Apps allow skip auth - Admin part #3028
- Admin - few small changes #3039
- Fix idle page link, IE Edge #3088

## [Dev:Build_338] - 2018-5-16
- Prettified stats message #2997
- Fix idle and text #2954

## [Dev:Build_337] - 2018-5-16
- Suspend foreground tabs (Admin text change) #2946
- In order to sign in to a browser, I need to add an application rule #2926
- DC Admin password is hidden now 
- Fixed CEF tag typo
- Fix app rules for profiles with no rules
- Silence idle timeout socket close error from logs

## [Dev:Build_336] - 2018-5-15
- FIX - DNS Container took external dns settings #3045
- DNS - can't reach internal web sites #3030
- Perf test labels & fix ready-to-show #2888
- Fix ldap refresh browser crash JSON parse
- Periodic Test - when change the frequency at the admin, it shows time in sec for splitt sec #2741
- (*) Kibana is not working on build 335 #3041
- (*) Apps allow skip auth - Admin part #3028
- Page load test page #2888
- When System reach to max capacity there is no alert #2841
- Periodic Test - when change the frequency at the admin, it shows time in sec for splitt sec #2741
- (*) multi node - proxy not found , no ping to icap-server, bad address #2697


## [Dev:Build_335] - 2018-5-14
- On ext-proxy internal-dns servers should be used when no ext-servers are specified #3014
- Support per node alerts ( for CPU, Memory , Disk ) #3006
- DNS settings at the admin should be limited only to IP address #3001
- Alert when DNS setting are not set #2980
- Minimised view of page after reloading or opening new tab in Firefox on Linux machine. #2961
- Can't create new account for google drive with shield #2944
- Add an alert when disk is low for storing the logs #2824
- Browser service restart policy is set to none in -quickeval #2958
- Improve setting init zoom #2961 #2992
- Nameservers are not set from resolv.conf #3015
- Updated jp translation file
- Support for Apps that cant authenticate - backend side 


## [Dev:Build_334] - 2018-5-13
- Proxies will use dns container #2969
- (*) Fix blank child windows #2968
- Add averageCpuCorePerSession & averageMemoryPerSession to uploaded shield stats #2997
- Add health check to DNS issue at the ext proxy #3002
- Sometimes I can't browse using mini sanity machine #2800


## [Dev:Build_333] - 2018-5-10
- FPS idel time out should be limited for foreground only #2901
- Send Anonymous Feedback - false by default
- When not typing the full URL, redirect fails (Reported by BTL) #2853
- Upload shield status once per 24 hours. Include stats sampled once an hour #2938
- Consul back up restore failed #2827
- Update node to the latest LTS (currently 8.x)
- Better Alert mail texts #2941
- Mail support list of recipients
- Ext proxy support for ADBlock, DNS caching and Using direct 
- Application issue in Admin UI #2959
- Resources Saver Timeout (min) - change location at the admin #2947
- Admin UI for DNS and Ad-blocks #2940
- Idle timeout - Not working #2954
- Write shield stats to ELK
- Suspend forground tabs #2946
- Applications -default and override rules do not support multi profile #2937
- Apps support in Shield #1525
- DNS resolving is not cached when using caching (Ext proxy) #2793
- Store Connection Pref report in ELK #2986


## [Dev:Build_332] - 2018-5-8
- Admin - loading indicator always on - error on page #2866
- When disable cache I need to rescale browsers #2878
- Broker waits for service which already been cleared #2919
- Filter internal domains from app rules log 
- Add new application dialog #2923
- Apps support in Shield #1525
- Block ftp protocol - not shield it #2689
- Added internal page - http://page-perf/
- DNS caching in ext-proxy

## [Staging:18.05-Staging:Build_331] - 2018-5-06
- When cache is enabled it behave as a proxy and XFF list contain cef IP #2877
- Block ftp protocol - not shield it #2689
- Allow blacklist req in authproxy #2889
- Bugfix the alerts settings are removed #2893
- install-certificate now provide the real CA certificate 
- Remote Browser will write log per level set in the Admin - reduce logs 
- Analyzer Report #2865
- Log Apps request #2325

## [Dev:Build_331] - 2018-5-3
- When cache is enabled it behave as a proxy and XFF list contain cef IP #2877
- Block ftp protocol - not shield it #2689
- Allow blacklist req in authproxy #2889
- Bugfix the alerts settings are removed #2893
- install-certificate now provide the real CA certificate 
- Remote Browser will write log per level set in the Admin - reduce logs 
- Analyzer Report #2865
- Log Apps request #2325

## [Staging:18.05-Staging:Build_330] - 2018-5-03
- (*) Lower FPS on idle page #2802
- Broker findAndKillZombies() function is not implemented correctly #2851
- Gmail on Chrome (small window) - stuck #2845
- If screen DPI scale > 100%, browser resizes too late #2844
- Broker should not create new services if browsers are not registering to consul #2838
- Admin UI for "Notifier" #2506
- Window resize throttle & init zoom #2844 #2845
- Apps are allowed by default
- Consul backup should lock writing file #2828
- Consul back up restore failed #2827
- Alert via Email was fixed
- When adding nodes and there is a problem we should display some error for the user #2411
- Error when adding nodes #2452
- App rules support both text and regex 

## [Dev:Build_330] - 2018-5-2
- (*) Lower FPS on idle page #2802
- Broker findAndKillZombies() function is not implemented correctly #2851
- Gmail on Chrome (small window) - stuck #2845
- If screen DPI scale > 100%, browser resizes too late #2844
- Broker should not create new services if browsers are not registering to consul #2838
- Admin UI for "Notifier" #2506
- Window resize throttle & init zoom #2844 #2845
- Apps are allowed by default
- Consul backup should lock writing file #2828
- Consul back up restore failed #2827
- Alert via Email was fixed
- When adding nodes and there is a problem we should display some error for the user #2411
- Error when adding nodes #2452
- App rules support both text and regex 

## [Dev:Build_329] - 2018-5-1
- Apps support in Shield (backend part) #1525 
- Alligend tests for each run scenario
- On-demand test results should be uploaded if user allows #2819
- Admin alerts text fixes 
- Log Apps request #2325

## [Dev:Build_328] - 2018-4-30
- Reduce logs of CEF
- Admin UI -Alerts - can't type in some fields #2836
- Update "Ericom Shiled repo " #2830
- No Alert for DNS failures #2817
- Upload alert (via notifier) to include the alert severity #2814
- DNS alert should be a single line #2796
- Bad Analyzer results for Platform info test #2782
- Admin - FQDN warning message for the user is not enough #2733
- Admin UI for "Notifier" #2506
- Sometimes at broker log I see "Elastic not deployed. Alerts will not be persist" #2497

## [Dev:Build_327] - 2018-4-29
- HTTP Headers (Forward/Set/Remove) #2694

## [Dev:Build_326] - 2018-4-26
- Collect usage stats every hour #2804
- Send user usage info #2775
- Admin UI for "Notifier" #2506
- Upgrade to Docker 18.03.0-ce (2018-03-21)

## [Dev:Build_325] - 2018-4-24
- Allow already connected users even if license limit #2717
- No alert when DNS is down #2758
- Small fix for warning/error levels for #2781
- License logic - can't open more tabs after reach to max license #2717
- Pre check install shows duplicate for warning and faulire and no ranges for drive speed #2781
- Pre check install script - please add the normal, warning and failure ranges #2515
- Add "Refresh AD Cache" button to the Admin UI #2696

## [Dev:Build_324] - 2018-4-23
- Pre check install script -the memory test prints ok for 8GB #2761
- No alert when DNS is down #2758
- Restart autoupdate service. #2738
- Analyzer results new report #2679
- Pre check install script - please add the normal, warning and failure ranges #2515

## [Dev:Build_323] - 2018-4-22
- Add lync user agent
- Japanese - alt+kana roman key type the current mode #2368
- some periodic tests are failed to be executed #2743

## [Dev:Build_322] - 2018-4-18
- Collector periodic and on-demand tests doesn't show all tests #2730
- Analyzer results new report - item 1 #2679
- The alert "checked installed memory failed on the following nodes" - change the content #2513

## [Dev:Build_321] - 2018-4-17
- (*) Fix too many extra buffers - should help sessions that get stcuk
- Periodic Test should be configurable #2580
- Analyzer fix to show up to 35 results
- The alert "checked installed memory failed on the following nodes" - change the content #2513
- update from prod to staging should copy all files #2661
- Remove URLs from 1030-connectivity.sh test results


## [Dev:Build_320] - 2018-4-17
- Version file typo fix
## [Dev:Build_319] - 2018-4-16
- Add new profile -fix tab functionality to navigate to "Add" button #2342
- change the "scale to" formula #2542
- Scaleto can bypass the system capacity #2576
- Periodic Test should be configurable #2580
- Scale to should not be executed in case shield is not activated #2614
- Update from prod to staging should copy all files #2661
- Should override key pairs file when generate ./update.sh ssthkey #2669
- The broker should not start before main browser service? #2681
- When reboot shield machine, the broker doesn't wait for the main browser service #2698
- Uptoupdate did not work #2702
- Auth Proxy - set ipv4 dns first


## [Dev:Build_318] - 2018-4-15
- Admin - FQDN is updated - add pop up message and reload page #2690
- Block ftp protocol - not shield it #2689
- Advanced License counting #2658
- Support for spellcheck - English(US) only #1488

## [Dev:Build_317] - 2018-4-12
- SHIFT+left click not working well with Office online #2364
- Admin: Generate the keytab command #1810
- ADMIN - profiles - fields with previous values #1534
- AD settings were completed but couldn't add a new policy #2454
- Implement 1030-connectivity.sh test for collector
- Internal page to measure sites loading time (P2) #2290
- Collector periodic and on-demand tests are broken #2643
- Page display is slow when press on back arrow (P2) #545


## [Staging:18.04-Staging:Build_312.1] - 2018-4-11
- Chrome version used by shield should be updated #2662
- Allow IE11 with compat user agent (inc. apps)
- The broker should not start before main browser service? #2681
- Scale to should not be executed in case shield is not activated #2614
- Scaleto can bypass the system capacity #2576
- Scale to is being skipped and no new service is created when it should #2575
- Change the "scale to" formula #2542

## [Dev:Build_316] - 2018-4-10
- Intercept and proxy 'mailto' links  #1276
- Admin - Analyzer - Fixed Run Client Analyzer address #2619
- Admin - Settings - FQDN default value #2616
- Admin - Profiles - fields with previous values #1534
- Autoupdate to ignore pre-installation checks #2207

## [Dev:Build_315] - 2018-4-10
- Periodic tests bad mearge fix
- Print test thresholds in case it didn't pass #2515
- Always check real IE engine version #2651
- Ugrade electron to 1.8.4 #2634
- Fixed upload expected status code #2647
- Added 1050-number-of-cpus.sh test to all 3 modes #2574
- Collector periodic and on-demand tests are broken #2643
- update.sh not execute docker version update on worker node. #3164
- collector image when running update is old #2855

## [Dev:Build_314] - 2018-4-9
- Fixed icap tag
- Consul: No Cluster Leader #2428

## [Dev:Build_313] - 2018-4-9
- Valid default CEF certificates in debugging #2549
- Gmail on IE redirected to a basic HTML version #2329 
- Expedia opens new empty tab - method not allowed #2271
- Expedia web site - when open new tab, no indication for the user that page is loading #2232 
- Browsers are stopping to work when consul leader is going down #1308 
- Change text for limited sessions #2562 
- Use apps rule for gdocs offline request #2442 
- Application user agent regexps in consul #1525 
- Update browser not supported text #2365 
- MAC scrolling is not smooth , throttle scroll events to 50ms  #2610 
- Work with IE compatibility mode #2365 
- When opening few tabs at one time, other tabs remain blank #2441 #1390 #2621
- Drop down list does not work in partners.microsoft.com (within a pop up window) #2180 
- Remove YT only fms #2200
- Closing an Alert in Elastic using the correct index #2540
- Issue #2506
- Fixed globalResult in case of Internal Error #2280
- Added logs to debug issue #2497
- Added log-level setting to the Collector #2632
- Fixed on-demand tests triggered for the first time #2619
- Fix broker fatal error when service not found , Failed scale browser service #2626
- Consul settings for periodic tests #2580 
- Added alertNodesNotInReadyState #2493
- TAB key not working as expected #2363
- Search does not start without a space - keyup was not firing #1920 
- Admin profiles tab order #1352 
- Added button to open client analyzer #2238
- Admin dialogs autofocus #1382
- Admin/Policies - replace the current setting icon and use the fa-slider icon 
- Admin - Resources - incorrect tab order #2000
- Fix https removal when adding policies url #2393
- The white circle is not centered when sanitize a file #2045
## [Staging:18.04-Staging:Build_312] - 2018-4-5
- Updated Admin

## [Dev:Build_312] - 2018-4-8
- Remote Browser fix for Upload attachments #2602
- Admin - fixed table for analyzer , updated tooltips #2538

## [Dev:Build_309] - 2018-3-28
- Admin Analyzer #2538
- Admin - Settings - SSL (new section) #2546
- Admin Updated Japanese translation

## [Dev:Build_308] - 2018-3-27
- Test that fails to execute should be skipped #2547
- Fix update.sh sshkey  

## [Dev:Build_307] - 2018-3-27
- Scale is not working in build 306 #2535
- Admin Fields - names + tooltips updates #2523
- When browsing to untrusted site every resource causes a prompt #2521
- Admin UI - Policies - if the profile name is long the display is not looking good #2432
- Admin - Policies - Searchbox #2374
- Scale formula should be changed - too many services are created #2542

## [Dev:Build_306] - 2018-3-26
- Failed to install build 304-Dev - pre check fails #2501
- Pool management - the same service is being recreated with new pool #2494
- Scale -broker should scale up number of min available browsers when admin set higher number #2451
- Stand by remote browsers on admin ui should not allow to set less then 20 browsers #2450
- Scale -Shield-broker created 2 services at same time #2424
- New Browser Pool Management #2369
- "BROWSER SCALE UNCHAUGHT EXCEPTION" #2498
- Fix some CEF crashes when closing #2476
- Update default rate limit 10/100s #2375

## [Dev:Build_305] - 2018-3-25
- More fields when uploading shield-stats to external database #2477
- Log for update.sh is needed #2419
- Update.sh script should display warning to create sshkey first #2416
- (*) New Docker version: 17.12.1 #2324
- New Shield CLI Commands: (start.sh/update.sh/addnodes.sh/nodes.sh/etc) #1818
- New pre-install-check script (running collector container)
- Shield Setup running new pre-install-check script
- New Update mechanism (ansible based)

## [Dev:Build_304] - 2018-3-23
- Typo fix in version file

## [Dev:Build_303] - 2018-3-23
- Fix 100% cpu bug

## [Dev:Build_302] - 2018-3-22
- Don't kill bg tabs while media playing #2453
- Install fonts-ipafont-gothic and fonts-ipafont-mincho
- Show hovered links in bottom status bar #1245
- Added fonts for emojis and weird langs #2427
- Support for shield to use Customer CA (R2) #310
- Pre install checks V2 #2088
- Consolidate pre-check test and alerts #2282
- Integrate SRT into the admin #2238
- Browser crash? #2476
- Idle timeout terminated an audio session #2453
- Youtube.com some languages doesn't appear via shield #2427
- shield with IE 8 - urls in white mode #2350


## [Dev:Build_301] - 2018-3-21
- Added load-test page back to icap
- Fixed Votiro not available alert #2447
- Read systemID from Consul instead of accessing the secret file
- Fixed tests paths (didn't work in "on-demand" mode) 
- Updated texts in Admin for Votiro HA and Secure LDAP
- Updated scale formula + delay in start
- FMS - msep works cross-iframe, fix some crash 

## [Dev:Build_300] - 2018-3-20
- FMS - allow server play if client playing #1872 #2298
- FMS - Cache codec support client-side #1872
- Use scale_step for scale operations #2429
- Added support for secured LDAP #1148
- Shield shows page from yesterday on One #2020
- Admin: Change Password (?)

## [Dev:Build_299] - 2018-3-19
- Set language browser props from client #2323
- Typing issue on IE and Edge #2333
- Fixed shield-notifier health check
- Paused movies removed from DOM #2298 #1872
- Japanese commit mixup hotfix

## [Dev:Build_298] - 2018-3-19
- Certificate error rule is not working #2392
- KKA-QA#684141 Does not automatically change the input mode in passward field. #91 #2386
- Korean - typing alpah numeric full width is not working in chrome #2372
- New Browser Pool Management #2369
- KKA - The cursor does not move when entering double-byte space #2362
- KKA -Character conversion problem with function key #2361
- Ctrl+shift+arrows issues #2348
- Shield-Broker scale browser scaling is wrong on Node fails #2312
- Page is refreshed from time to time #1991
- (*) fix edge&IE crash can't watch movies on some sites #2394

## [Dev:Build_297] - 2018-3-18
- Changed Shield-Alert to be written as "report" #2326 
- Infrustructure for consolidating alerts and pre-install tests #2282
- Improve pre-test result ui ,color 

## [Dev:Build_296] - 2018-3-18
- Admin - Generate the keytab command #1810
- Admin - policies - general tooltip #2379
- Generic FMS - #1872 #2298 #2200 

## [Dev:Build_295] - 2018-3-14
- keybaord fixes  #2242 #2144 #2191 #2243 #2257
- Autoupdate on multi machin from old prod to current prod failed to update the version #2347
- Download "Blocked" instead of "Failed" #2345
- Printing Enabled/Disabled Policy (R2) #654
- Exception List for https w/o Trusted Certificate (B2) #875
- Update policies - Main issue #2335
- Add FMS flag in the polices #2300
- System should work even if ELK is not present #2195
- korean space typing issue #2257
- Korean - ctrl A doesn't work as expected #2243
- Left arrow issue when using Japanese #2191
- Japanese henkan key doesn't work as expected #2144
- Korean duplicate issue #2242

## [Dev:Build_294] - 2018-3-13
- Fixed type in version file

## [Dev:Build_293] - 2018-3-12
- Media page to examine offline experience #2280
- Improved Speedtest UI #2280
- Update jquery in AN from 1.x to 3.x - improve security #1906
- Admin should support HTTPS only (R2 B2) #513
- Change "Download Failed" message title to "Download Blocked" when file was blocked by Votiro #2345
- Alerts are missing from Syslog #2326
- Upgraded portainer to 1.16.2

## [Staging:18.03-Staging:Build_292] - 2018-3-6
- Admin - pac file related fields #2279
- Admin - Licensing - Licenses in use #2274
- Admin - Updated ja-jp.json
- Admin - fix issue with pacfile downloaded notification #2279
- Admin - added proper tooltips for uk/us #2274
- Admin - removed password from command
- Remote Browser - accept invalid certs using dialog #2236
- Admin - Licensing - Licenses in use #2274
- Invalid certificate error when going to cnn.com #2297
- (*) auth proxy ignore https errors (Windows Update) #2302

## [Dev:Build_291] - 2018-3-5
- Admin - Licensing - Licenses in use #2274
- Invalid certificate error when going to cnn.com #2297

## [Dev:Build_290] - 2018-3-1
- Admin - pac file related fields #2279
- Admin - Licensing - Licenses in use #2274
- Admin - Updated ja-jp.json
- Admin - fix issue with pacfile downloaded notification #2279
- Admin - added proper tooltips for uk/us #2274
- Admin - removed password from command
- Remote Browser - accept invalid certs using dialog #2236

## [Staging:18.03-Staging:Build_289] - 2018-3-1
- IME should work on IE 11 #2187
- Canvas resize color white #2272
- Admin - Show notification "Details" column only if there is an alert which includes a URL #2058
- Admin - Reports doesn't work. #2278

## [Dev:Build_289] - 2018-2-28
- IME should work on IE 11 #2187
- Canvas resize color white #2272
- Admin - Show notification "Details" column only if there is an alert which includes a URL #2058
- Admin - Reports doesn't work. #2278

## [Dev:Build_288] - 2018-2-27
- (*) Fix broker browser refresh (#2258)
- No license message should be written to log once per day #2249
- Speedtest container image #2137
- OVA quick - reports section should not be displayed at the admin #2229
- No license message should be written to log less #2249
- ExperimentalUpload shield activations result to external database #2250
- Going out of fullscreen, session is displayed on just a portion of the page #2255 
- (*) Page is refreshed from time to time #1991
- Fix setting used to block apps; fix icap same logic as authproxy #2251
- Added Precheck for Kernel version , Memory

## [Dev:Build_287] - 2018-2-26
- Fix arrows and backspace-like keys in IE #2237 #2188
- Experimental Upload shield-stats to external database #2209
- Proper message when consul is not working instead of Invalid Credentials #2204
- Fixed basic auth md5 salt so authproxy doens't reconfigure
- Admin - Settings - Content Isolation #2245
- Speedtest container image #2137
- Added Test to preinstall script ( Checking virtualization platform, Gathering some system information, Testing cpu performance)

## [Staging:18.03-Staging:Build_286] - 2018-2-25
- Admin: Add new profile - the Add button was disabled #2120
- Admin: Generate the keytab command #1810
- Admin: Proper message when consul is not working instead of Invalid Credentials #2204
- Admin: Added proxy configuration collapsable area as requested in + updated tooltips #2062
- Admin - Add new profile is not sunc with the current state #1392
- Admin - Can't disable NTLM #2127
- Admin - Policies table #1694
- Admin - Rename proxy file to be default.pac #1568
- Admin - Add new profile is not sunc with the current state #1392
- Admin - Enabled autocomplete for profiles fields #1534
- Admin - fixed admin tooltip for Upstreamernal
- Admin - moved tooltip from right to be close to the text
- High Number of Critical Error Alert is confusing #2184
- Experimental Upload alerts to an external Database #2202
- Experimental Youtube only FMS #2200
- Updated tooltip and input for download max size #1409
- Authproxy squid reconfigure leaves zombie shield_policy_acl.js processes #2217
- Thai font do not display in Shield #2185
- Cross Window - Cisco Login #1655
- Added alert debug logs
- Re-implemented node docker failure alert
- Log alerts events in a new report #1778
- Japanese IME bugfix
- Keyboard fixes for korean and japanese
- Fix page refresh method #2122
- Icap should have mergeable values for defaults using consul source #2163
- Backspace is not working correctly in Japanese #2149
- Arrows are not working #2148
- Firefox does not reload when it should #
- Typing in Korean Issue #1938
- Office online right click menu copy paste - shows but does not function #1463
- Fix browser stuck dragging in SHIFT/CTRL+click link
- Log alerts events in a new report #1778
- Fixed profile bug in ICAP
- Daily Backup for last 10 days #1915
- From create, submit, window open in the same tick - Totalsource.adp.com #2009
- No preview for gmail attached PDF #1912
- .aflac.com - cannot run 2017 report ("Download failed" error message) #1820
- Cross Windows - Hotel.com #1657
- Cross windows Bank Hapoalim - download excel #786
- Pre-check Installer Shield #2068
- Pre-install check ubuntu and kernel version #2037

## [Prod:18.02-1-Build-280.3] - 2018-02-20
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

## [Dev:Build_286] - 2018-2-22
- High Number of Critical Error Alert is confusing #2184
- Admin: Add new profile - the Add button was disabled #2120
- Admin: Generate the keytab command #1810
- Admin: Proper message when consul is not working instead of Invalid Credentials #2204
- Admin: Added proxy configuration collapsable area as requested in + updated tooltips #2062
- Experimental Upload alerts to an external Database #2202
- Experimental Youtube only FMS #2200
- Updated tooltip and input for download max size #1409
- Authproxy squid reconfigure leaves zombie shield_policy_acl.js processes #2217

## [Dev:Build_285] - 2018-2-20
- Thai font do not display in Shield #2185
 
## [Dev:Build_284] - 2018-2-20
- Cross Window - Cisco Login #1655
- Added alert debug logs
- Re-implemented node docker failure alert
- Log alerts events in a new report #1778

## [Dev:Build_283] - 2018-2-19
- Japanese IME bugfix
- Keyboard fixes for korean and japanese
- Fix page refresh method #2122
- Icap should have mergeable values for defaults using consul source #2163
- Backspace is not working correctly in Japanese #2149
- Arrows are not working #2148
- Firefox does not reload when it should #
- Typing in Korean Issue #1938
- Office online right click menu copy paste - shows but does not function #1463


## [Dev:Build_282] - 2018-2-15
- Admin - fixed admin tooltip for Upstreamernal
- Admin - moved tooltip from right to be close to the text
- Fix browser stuck dragging in SHIFT/CTRL+click link
- Log alerts events in a new report #1778
- Fixed profile bug in ICAP

## [Dev:Build_281] - 2018-2-14
- Daily Backup for last 10 days #1915
- Admin - Add new profile is not sunc with the current state #1392
- Admin - Can't disable NTLM #2127
- Admin - Policies table #1694
- Admin - Rename proxy file to be default.pac #1568
- Admin - Add new profile is not sunc with the current state #1392
- Admin - Enabled autocomplete for profiles fields #1534
- From create, submit, window open in the same tick - Totalsource.adp.com #2009
- No preview for gmail attached PDF #1912
- .aflac.com - cannot run 2017 report ("Download failed" error message) #1820
- Cross Windows - Hotel.com #1657
- Cross windows Bank Hapoalim - download excel #786
- Pre-check Installer Shield #2068
- Pre-install check ubuntu and kernel version #2037

## [Dev:Build_280] - 2018-2-12
- Prevent ntlm from crashing when wrong DC address #2095
- Activation: Key already in use #1866
- Fix shield-stats #2100
- Remote Browsers are not starting after reboot #2092

## [Dev:Build_279] - 2018-2-11
- ICAP Async rewrite 
- Broker will clean dead failed CEF #2092
- set higher error rate for alert 5->30
- Improved Docker CEF report

## [Dev:Build_278] - 2018-2-7
- Added alert when system requires activation
- Admin takes long to load when no internet #1902
- Fixed alerts initialization at broker startup #1778
- Admin - policies - default values are taken from the current profile in focus #1793
- all data is lost after adding 2 nodes and running script to switch consul mode #2065
- Cross windows -booking.com #2049
- backup service is not running on the leader and user need to restore the data #2047
- Test Upgrade from Prod to Staging #1974
- Open new tab? notification is displayed when open link with middle click #1900
- Implement Keepalive with Votiro Server #1828
- Emirates.com - Can't click on the website. #1430

## [Dev:Build_277] - 2018-2-6
- Fixed CDR tag

## [Dev:Build_276] - 2018-2-5
- Using update consul lib (0.30.0)
- Downloads of direct links do not work : "Download Disabled" message #2027
- Blacklist Policy rows should be also strikethrough #2022
- Publishing dynamic PAC files #1988
- shield-stats: move sessions section under license #1966
- IE mode - fails to connect check "AS is running and reachable" #1961
- The leader node IP displayed is 0.0.0.0 #1739
- Admin Dashboard with long urls #1956
- When adding a new profile I can set Profile Name that is already in use #1941
- Add new profile - add is disabled in case you start with the second field #1939
- http://shield-stats/ - Alerts doesn't show #1929
- Daily Backup for last 10 days #1915
- When changing the port on the admin the reports doesn't work #1914
- Add a notification that the pac file is being downloaded and not only being displayed #1893
- Admin - settings - pac file downloaded upon enter #1858
- Implement Keepalive with Votiro Server #1828
- Install new docker on deploy scripts #1785
- http://shield-stats shouldn't be available for everyone #1530
- File transfer - failure reports show no results #1499
- Open new tab? notification is displayed when open link with middle click #1900

## [Dev:Build_275] - 2018-1-31
- No error for urls (https) in black mode #1815
- Fix shield-blank #2012 and form post when cookies disabled
- CEF upgrade consul lib #2011 #1991
- New tab error - https://news.google.com/ #2012
- Shield shows page from yesterday on One

## [Dev:Build_274] - 2018-1-30
- Add DNS support for External proxy #1965
- Cross window resize problem #1998
- Use 2 ext proxies for HA

## [Dev:Build_273] - 2018-1-30
- Multi-node enabled by defualt 

## [Dev:Build_272] - 2018-1-29
- Force AN to never enable touchscreen mode
- Fix for SSL sites with auth ensbled #1957
- Exempt UA QtWebEngine ShangriLa.Fix dropbox UA
- Fix don't open new tab for regular forms #1654
- Replace localHostOrDomainIs with shExpMatch #1894
- Fixed CEF crash on rare cases 
- Consul flag for multi-window enable #1434
- Korean bug fixes 1984, 1979
- HTML form with method POST creates new window - cant print in EzPass site #1654
- Cross-Windows Failure printing a PDF on docusign.net #1762
- Kvish 6 - can't print receipt #1741
- Cross Window - open google drive / dropbox from yahoo is not working with shield #1319
- Cross window - Click Search in Kayak.com ("-->") - Nothing Happnes #983
- Can't open in google sheets/docs from gmail #665
- Cross Window - Salesforce can't open email HTML view #532

## [Dev:Build_271] - 2018-1-24
- Kerberos fails when using chrome #1897

## [Dev:Build_270] - 2018-1-24
- Rolled back HTML form with method POST creates new window - cant print in EzPass site #1654

## [Dev:Build_269] - 2018-1-23
- Fixed Auth proxy stuck in some cases
- Backup - should not be created when the settings are invalid #1919
- Data is not saved after adding nodes and running ericomshiled-setup -force #1908
- Need to delete duplicate backup files after x time #1905
- Enable/Disable Caching from the AdminUI #1895
- HTML form with method POST creates new window - cant print in EzPass site #1654
- Cross Window - open google drive / dropbox from yahoo is not working with shield #1319
- Cross-Windows Failure printing a PDF on docusign.net #1762
- Kvish 6 - can't print receipt #1741
- Cross Windows - Hotel.com #1657
- Cross Window - Salesforce can't open email HTML view #532

## [Dev:Build_268] - 2018-1-22
- Background Tab Timeout - Admin Policy Configuration (R1) #1681
- Min Available browser - 20 or calculated

## [Dev:Build_267] - 2018-1-22
- Cross Windows is in - but disabled
- Enable/Disable Caching from the AdminUI #1895
- After reboot new back up files are being created #1904

## [Dev:Build_265] - 2018-1-21
- (*) Fixed Default PAC file when using IE 11 #1894
- Quality_scroll_fps 20 -> 50
- Fixed high scale bug 

## [Staging:18.01-Build_249.7] - 2018-1-21
- Ignore upstream CA errors by default 
- Cookies are off by default 
- Fixed Default PAC file

## [Dev:Build_264] - 2018-1-21
- (*) Rework on Cookies support , fix page load getting stuck #1878

## [Dev:Build_263] - 2018-1-18
- Allow option to use ext proxy cache without upstream proxy - #1854
- Change auth.common.policy_matcher_ttl_minutes to 0.08 
- Cookies are off by default
- Append report to scale number #1888
- Background Tab Timeout - Admin Policy Configuration (R1) #1681 (admin part)

## [Dev:Build_262] - 2018-1-18
- Implement Keepalive with Votiro Server #1828
- Dashboard indicators (always write alerts, Votiro KeepAlive alert) #1879
- Lower image quality during scroll

## [Dev:Build_261] - 2018-1-18
- Updated proxy server

## [Dev:Build_260] - 2018-1-17
- Fix right click on hovered links #1874
- External Proxy Support #1574
- Restore Command available from outside #1609

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

## [Dev:Build_284] - 2018-2-20
- Cross Window - Cisco Login #1655
- Added alert debug logs
- Re-implemented node docker failure alert
- Log alerts events in a new report #1778

## [Dev:Build_283] - 2018-2-19
- Japanese IME bugfix
- Keyboard fixes for korean and japanese
- Fix page refresh method #2122
- Icap should have mergeable values for defaults using consul source #2163
- Backspace is not working correctly in Japanese #2149
- Arrows are not working #2148
- Firefox does not reload when it should #
- Typing in Korean Issue #1938
- Office online right click menu copy paste - shows but does not function #1463


## [Dev:Build_282] - 2018-2-15
- Admin - fixed admin tooltip for Upstreamernal
- Admin - moved tooltip from right to be close to the text
- Fix browser stuck dragging in SHIFT/CTRL+click link
- Log alerts events in a new report #1778
- Fixed profile bug in ICAP

## [Dev:Build_281] - 2018-2-14
- Daily Backup for last 10 days #1915
- Admin - Add new profile is not sunc with the current state #1392
- Admin - Can't disable NTLM #2127
- Admin - Policies table #1694
- Admin - Rename proxy file to be default.pac #1568
- Admin - Add new profile is not sunc with the current state #1392
- Admin - Enabled autocomplete for profiles fields #1534
- From create, submit, window open in the same tick - Totalsource.adp.com #2009
- No preview for gmail attached PDF #1912
- .aflac.com - cannot run 2017 report ("Download failed" error message) #1820
- Cross Windows - Hotel.com #1657
- Cross windows Bank Hapoalim - download excel #786
- Pre-check Installer Shield #2068
- Pre-install check ubuntu and kernel version #2037

## [Dev:Build_280] - 2018-2-12
- Prevent ntlm from crashing when wrong DC address #2095
- Activation: Key already in use #1866
- Fix shield-stats #2100
- Remote Browsers are not starting after reboot #2092

## [Dev:Build_279] - 2018-2-11
- ICAP Async rewrite 
- Broker will clean dead failed CEF #2092
- set higher error rate for alert 5->30
- Improved Docker CEF report

## [Dev:Build_278] - 2018-2-7
- Added alert when system requires activation
- Admin takes long to load when no internet #1902
- Fixed alerts initialization at broker startup #1778
- Admin - policies - default values are taken from the current profile in focus #1793
- all data is lost after adding 2 nodes and running script to switch consul mode #2065
- Cross windows -booking.com #2049
- backup service is not running on the leader and user need to restore the data #2047
- Test Upgrade from Prod to Staging #1974
- Open new tab? notification is displayed when open link with middle click #1900
- Implement Keepalive with Votiro Server #1828
- Emirates.com - Can't click on the website. #1430

## [Dev:Build_277] - 2018-2-6
- Fixed CDR tag

## [Dev:Build_276] - 2018-2-5
- Using update consul lib (0.30.0)
- Downloads of direct links do not work : "Download Disabled" message #2027
- Blacklist Policy rows should be also strikethrough #2022
- Publishing dynamic PAC files #1988
- shield-stats: move sessions section under license #1966
- IE mode - fails to connect check "AS is running and reachable" #1961
- The leader node IP displayed is 0.0.0.0 #1739
- Admin Dashboard with long urls #1956
- When adding a new profile I can set Profile Name that is already in use #1941
- Add new profile - add is disabled in case you start with the second field #1939
- http://shield-stats/ - Alerts doesn't show #1929
- Daily Backup for last 10 days #1915
- When changing the port on the admin the reports doesn't work #1914
- Add a notification that the pac file is being downloaded and not only being displayed #1893
- Admin - settings - pac file downloaded upon enter #1858
- Implement Keepalive with Votiro Server #1828
- Install new docker on deploy scripts #1785
- http://shield-stats shouldn't be available for everyone #1530
- File transfer - failure reports show no results #1499
- Open new tab? notification is displayed when open link with middle click #1900

## [Dev:Build_275] - 2018-1-31
- No error for urls (https) in black mode #1815
- Fix shield-blank #2012 and form post when cookies disabled
- CEF upgrade consul lib #2011 #1991
- New tab error - https://news.google.com/ #2012
- Shield shows page from yesterday on One

## [Dev:Build_274] - 2018-1-30
- Add DNS support for External proxy #1965
- Cross window resize problem #1998
- Use 2 ext proxies for HA

## [Dev:Build_273] - 2018-1-30
- Multi-node enabled by defualt 

## [Dev:Build_272] - 2018-1-29
- Force AN to never enable touchscreen mode
- Fix for SSL sites with auth ensbled #1957
- Exempt UA QtWebEngine ShangriLa.Fix dropbox UA
- Fix don't open new tab for regular forms #1654
- Replace localHostOrDomainIs with shExpMatch #1894
- Fixed CEF crash on rare cases 
- Consul flag for multi-window enable #1434
- Korean bug fixes 1984, 1979
- HTML form with method POST creates new window - cant print in EzPass site #1654
- Cross-Windows Failure printing a PDF on docusign.net #1762
- Kvish 6 - can't print receipt #1741
- Cross Window - open google drive / dropbox from yahoo is not working with shield #1319
- Cross window - Click Search in Kayak.com ("-->") - Nothing Happnes #983
- Can't open in google sheets/docs from gmail #665
- Cross Window - Salesforce can't open email HTML view #532

## [Dev:Build_271] - 2018-1-24
- Kerberos fails when using chrome #1897

## [Dev:Build_270] - 2018-1-24
- Rolled back HTML form with method POST creates new window - cant print in EzPass site #1654

## [Dev:Build_269] - 2018-1-23
- Fixed Auth proxy stuck in some cases
- Backup - should not be created when the settings are invalid #1919
- Data is not saved after adding nodes and running ericomshiled-setup -force #1908
- Need to delete duplicate backup files after x time #1905
- Enable/Disable Caching from the AdminUI #1895
- HTML form with method POST creates new window - cant print in EzPass site #1654
- Cross Window - open google drive / dropbox from yahoo is not working with shield #1319
- Cross-Windows Failure printing a PDF on docusign.net #1762
- Kvish 6 - can't print receipt #1741
- Cross Windows - Hotel.com #1657
- Cross Window - Salesforce can't open email HTML view #532

## [Dev:Build_268] - 2018-1-22
- Background Tab Timeout - Admin Policy Configuration (R1) #1681
- Min Available browser - 20 or calculated

## [Dev:Build_267] - 2018-1-22
- Cross Windows is in - but disabled
- Enable/Disable Caching from the AdminUI #1895
- After reboot new back up files are being created #1904

## [Dev:Build_265] - 2018-1-21
- (*) Fixed Default PAC file when using IE 11 #1894
- Quality_scroll_fps 20 -> 50
- Fixed high scale bug 

## [Staging:18.01-Build_249.7] - 2018-1-21
- Ignore upstream CA errors by default 
- Cookies are off by default 
- Fixed Default PAC file

## [Dev:Build_264] - 2018-1-21
- (*) Rework on Cookies support , fix page load getting stuck #1878

## [Dev:Build_263] - 2018-1-18
- Allow option to use ext proxy cache without upstream proxy - #1854
- Change auth.common.policy_matcher_ttl_minutes to 0.08 
- Cookies are off by default
- Append report to scale number #1888
- Background Tab Timeout - Admin Policy Configuration (R1) #1681 (admin part)

## [Dev:Build_262] - 2018-1-18
- Implement Keepalive with Votiro Server #1828
- Dashboard indicators (always write alerts, Votiro KeepAlive alert) #1879
- Lower image quality during scroll

## [Dev:Build_261] - 2018-1-18
- Updated proxy server

## [Dev:Build_260] - 2018-1-17
- Fix right click on hovered links #1874
- External Proxy Support #1574
- Restore Command available from outside #1609

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
