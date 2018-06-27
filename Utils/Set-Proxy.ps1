
function Configure-Proxy ($Proxy, $Port)
{
# Function that actually does the configuring of the proxy settings.
Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyEnable -Value 1
Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyServer -Value $Proxy":"$Port
Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyOverride -Value "&lt;local&gt;"
}

while(true){
  start-sleep -s 60
  Set-Proxy
}

Function Set-Proxy
{
#  $NetworkConfig = @(ipconfig.exe /all)
  $a = Get-NetAdapter | Where-Object {$_.status -eq "Up"}
  $b = $a.ifIndex
  $NetworkConfig = Get-DnsClient -InterfaceIndex $b

  $Proxy = "shield-jer"
  $Port = "3128"
  $Network = "google.local"

 
  # If the network name found by the NIC matches to one in the CSV the proxy
  # settings are configured by parsing the right values to the Configure-Proxy function.
#  if ( $NetworkConfig -like "$Network" )
  if ($NetworkConfig.suffix -eq "$Network")
    {
#    $msgBoxInput =  [System.Windows.MessageBox]::Show('You are at the office in Network. Would you like to set the Proxy?','Setting Proxy','YesNo','Info')
#    switch  ($msgBoxInput) {
#    'Yes' {
          Configure-Proxy $Proxy $Port
#          }
#    'No' {
    ## Do something
#        }
#     }	  
    }
    # If no value applies, disable the proxy configuration.
   else
    {
      Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyEnable -Value 0
    }
}
 
#Function Set-Proxy-Csv
#{
#  $NetworkConfig = @(ipconfig.exe /all)
#  $Match = $false
#  ForEach ($customer in $customers)
#  {
#    $Port = $Customer.Port
##    $Proxy = $Customer.Proxy
#    $Network = $Customer.Network
#    # If the network name found by the NIC matches to one in the CSV the proxy
#    # settings are configured by parsing the right values to the Configure-Proxy function.
#    if ($NetworkConfig -like "$Network")
#    {
#      Configure-Proxy $Proxy $Port
#      $Match = $true
#    }
#    # If no value applies, disable the proxy configuration.
#    elseif (!$match)
#    {
#      Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyEnable -Value 0
#    }
#  }
#}
