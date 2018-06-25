function FindProxyForURL(url, host) {
	//Default proxy names
	var proxy_ro = "PROXY 192.168.1.249:3128";
	var proxy_il = "PROXY 126.0.3.51:3128";
	var proxy_uk = "PROXY 131.107.2.112:3128";
	var proxy_us = "PROXY 192.168.35.98:3128";
	var proxy_mo = "PROXY 192.168.50.150:3128";
	
        // Resolve IP Address
        var resolvedDestIp = dnsResolve(host);
        // If Resolved IP is null, use DIRECT
//        if ("0.0.0.0" == resolvedDestIp) {
//        // DIRECT means that Shield is bypassed and Direct Connection is used 
//           return "DIRECT";
//        }
        // If Resolved IP is localhost, use DIRECT    
        if (resolvedDestIp && isInNet(resolvedDestIp, '127.0.0.0', '255.0.0.0')) {
           return "DIRECT";
        }
    	
	if (isPlainHostName(host) ||
		shExpMatch(host, "*.local") ||
		isInNet(resolvedDestIp, "192.168.35.0", "255.255.0") ||
		isInNet(resolvedDestIp, "192.168.50.0", "255.255.255.0") ||
		isInNet(resolvedDestIp, "131.107.2.0", "255.255.255.0") ||
		isInNet(resolvedDestIp, "192.168.1.0", "255.255.255.0") ||
		isInNet(resolvedDestIp, "126.0.0.0", "255.0.0.0"))
		return "DIRECT";
        // If the protocol is FTP, send direct.
        if (url.substring(0, 4)=="ftp:" )
           return "DIRECT";

        //   Example of Whitelist URL
        //   If the Host requested is "www.cnn.com", send direct.
        //   if (localHostOrDomainIs(host, "www.cnn.com"))
        //      return "DIRECT";

        //   Example of Whitelist based on Source IP Range
        //	If User IP is in a specific Subnet, Use Direct
        //	if (isInNet(myIpAddress(), "126.0.0.0", "255.0.0.0")) {
        //		return "DIRECT";
	
	//Romania Proxy
	if (isInNet(myIpAddress(), "192.168.1.0", "255.255.255.0")) {
		return proxy_ro;
	}
	// Israel Poxy
	if (isInNet(myIpAddress(), "126.0.0.0", "255.0.0.0")) {
		return proxy_il;
	}
	//UK Proxy
	if (isInNet(myIpAddress(), "131.107.2.0", "255.255.255.0")) {
		return proxy_uk;
	}
	//US Proxy
	if (isInNet(myIpAddress(), "192.168.35.0", "255.255.255.0")) {
		return proxy_us;
	}
	//Modiin Proxy
	if (isInNet(myIpAddress(), "192.168.50.0", "255.255.255.0")) {
		return proxy_mo;
	}


// DEFAULT RULE: All other traffic, use below proxy.
return proxy_il;

// DEFAULT RULE: All other traffic, use below proxies, in fail-over order.
// return "PROXY shield_server_1:3128; PROXY shield_server_2:3128";

}
