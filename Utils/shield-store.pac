 //##################################################
//#####   Ericom Shield PAC File                  ##
//#####  WARNING: This is an auto-generated file. ##
//#############################################BH###   

function FindProxyForURL(url, host) {
    // A proxy auto-config (PAC) file defines how web browsers can automatically choose the appropriate proxy server
    // for fetching a given URL. 
    // By Using a PAC file, the administrator will be able to define which sites will go via SHIELD and which ones will be DIRECT (no Proxy)
    // DIRECT means White-listed at the end-user browser side 

//   Important Note: fResolvedIp flag should be set to 'false' for best performance, 
//   Set it to true, only if you need to define rules based on destination IP
    var fResolveIp = false;	
    // Replace SHIELD_IP with your Shield IP Server
    var shield_server = "shield-proxy.ericomcloud.net"; 
//var shield_server = "togo-proxy.shield-service.net"; 
    // Replace SHIELD_PORT if changed:
    var shield_port = "3128"
    var shield_proxy = "PROXY " + shield_server + ":" + shield_port + ";";

    // host is the url domain e.g. google.com for www.google.com
    host = host.toLowerCase();
    // DIRECT means that Shield is bypassed and Direct Connection is used 
	  
    // Shield Server doesnt require a Proxy
    if ( shExpMatch(host, shield_server) ) {
       return "DIRECT";
    }    

    //   If the Host requested is "shield-xxx" (used for troubleshooting shield), send it to Shield.
    if ( shExpMatch(host, "shield-") )
      return shield_proxy;
	
    // If the protocol is FTP, send direct.
    if (url.substring(0, 4)=="ftp:" )
       return "DIRECT";

    // If the requested website is hosted within the internal network (intranet), send direct.
    if ( isPlainHostName(host) ||
       shExpMatch(host, "*.local") )
       return "DIRECT";

//   Example of Whitelist URL based on Host or Domain
//   If the Host requested is "www.cnn.com", send direct.
//   Important Note: Same Policies should be added in Shield per Domain 
//	in order to cover use cases of redirection from Shield to White
//   if (shExpMatch(host, "*.cnn.com") || 
//       shExpMatch(host, "*.gov.il") )
//      return "DIRECT";

//	If User IP is in a specific Subnet, Use Direct
//   Important Note: isInNet is a function that can impact performance
//	if (isInNet(myIpAddress(), "126.0.0.0", "255.0.0.0")) {
//		return "DIRECT";

//	If User IP is in US Subnet, Set to US Proxy first
//	if (isInNet(myIpAddress(), "126.0.0.0", "255.0.0.0")) {
//		return proxy_us + proxy_il;
//	}
//  If User IP is in IL Subnet, Set to Israel Proxy
//	if (isInNet(myIpAddress(), "192.168.1.0", "255.255.255.0")) {
//		return proxy_il + proxy_us;
//	}
	   
    // Resolve IP Address for the host
    var resolvedDestIp = esDnsResolve();
	   
    if ( resolvedDestIp != "" &&
         ( isInNet(resolvedDestIp, "10.0.0.0", "255.0.0.0") ||
           isInNet(resolvedDestIp, "172.16.0.0",  "255.240.0.0") ||
           isInNet(resolvedDestIp, "192.168.0.0",  "255.255.0.0") ) ) {
                return "DIRECT";
         }
  
    // If Resolved IP is null, use DIRECT
    if (resolvedDestIp != "" && "0.0.0.0" == resolvedDestIp) {
       return "DIRECT";
    }
   
    // If Resolved IP is localhost, use DIRECT 
    if (resolvedDestIp != "" && isInNet(resolvedDestIp, '127.0.0.0', '255.0.0.0')) {
       return "DIRECT";
    }

    function esDnsResolve() {
        var sResolvedIp = "";

        if(host) {
            var isIpV4Address = /^(\d+.){3}\d+$/;
            if (isIpV4Address.test(host)) {
                sResolvedIp = host;
            } else if (fResolveIp && isResolvable(host)) {
                    sResolvedIp = dnsResolve(host);
            }
        }
	
        return sResolvedIp;
    }
// DEFAULT RULE: All other traffic, use below proxy.
return shield_proxy;

// DEFAULT RULE: All other traffic, use below proxies, in fail-over order.
// return "PROXY shield_server_1:3128; PROXY shield_server_2:3128";
}
