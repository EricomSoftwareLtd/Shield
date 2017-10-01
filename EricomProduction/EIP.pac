function FindProxyForURL(url, host) {
	//Proxy names for Ericom Proxies per Site
	var proxy_ro = "PROXY 192.168.1.249:3128";
	var proxy_il = "PROXY 126.0.3.51:3128";
	var proxy_uk = "PROXY 131.107.2.112:3128";
	var proxy_us = "PROXY 192.168.35.98:3128";
	var proxy_mo = "PROXY 192.168.50.150:3128";
	
        // If the requested website is hosted within the internal network, send direct.
        if (isPlainHostName(host) ||
           shExpMatch(host, "*.local") ||
           isInNet(dnsResolve(host), "10.0.0.0", "255.0.0.0") ||
           isInNet(dnsResolve(host), "172.16.0.0",  "255.240.0.0") ||
           isInNet(dnsResolve(host), "192.168.0.0",  "255.255.0.0") ||
           isInNet(dnsResolve(host), "127.0.0.0", "255.255.255.0") ||
           isInNet(dnsResolve(host), "131.107.2.0", "255.255.255.0") ||
	   isInNet(dnsResolve(host), "126.0.0.0", "255.0.0.0"))
        return "DIRECT";

	//If User IP is in Jer Subnet, Set to Jerusalem Proxy
	if (isInNet(myIpAddress(), "126.0.0.0", "255.0.0.0")) {
		return proxy_il;
	}
	//If User IP is in Ro Subnet, Set to Romania Proxy
	if (isInNet(myIpAddress(), "192.168.1.0", "255.255.255.0")) {
		return proxy_ro;
	}
	//If User IP is in UK Subnet, Set to UK Proxy
	if (isInNet(myIpAddress(), "131.107.2.0", "255.255.255.0")) {
		return proxy_uk;
	}
	//If User IP is in US Subnet, Set to US Proxy
	if (isInNet(myIpAddress(), "192.168.35.0", "255.255.255.0")) {
		return proxy_us;
	}
	//If User IP is in Modiin Subnet, Set to Modiin Proxy
	if (isInNet(myIpAddress(), "192.168.50.0", "255.255.255.0")) {
		return proxy_mo;
	}
	else return "DIRECT";
}
