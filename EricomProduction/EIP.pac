function FindProxyForURL(url, host) {
	//Default proxy names
	var proxy_ro = "PROXY 192.168.1.249:3128";
	var proxy_il = "PROXY 126.0.3.51:3128";
	var proxy_uk = "PROXY 131.107.2.112:3128";
	var proxy_us = "PROXY 192.168.35.98:3128";
	var proxy_mo = "PROXY 192.168.50.150:3128";
	if (isPlainHostName(host) ||
		shExpMatch(host, "*.local") ||
		isInNet(dnsResolve(host), "192.168.0.0", "255.255.0.0") ||
		isInNet(dnsResolve(host), "131.107.2.0", "255.255.255.0") ||
		isInNet(dnsResolve(host), "126.0.0.0", "255.0.0.0"))
		return "DIRECT";
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
	else return "DIRECT";
}
