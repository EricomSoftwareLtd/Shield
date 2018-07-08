#################################################################################
#####                      Ericom Shield Set Proxy Script                   #####
### Need to edit file and set correct values for shield server and pac file #####
### Need to run the file on the end-users’ laptops or add it to the GPO     #####
#########################################################################BH######

function Configure-Proxy ($Proxy, $Port)
{
   # Function that actually does the configuring of the proxy settings.
   Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyEnable -Value 1
   if( $Proxy )
   {
    Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyServer -Value $Proxy":"$Port
   }
   if( $PAC_file )
   {
    Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name AutoConfigURL -Value $PAC_file
   } 
   Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyOverride -Value "<local>;"
}

function Set-Proxy
{
#  $NetworkConfig = @(ipconfig.exe /all)
  $a = Get-NetAdapter | Where-Object {$_.status -eq "Up"}
  $b = $a.ifIndex
  $NetworkConfig = Get-DnsClient -InterfaceIndex $b

  $Proxy = "" # Set the Proxy Name or IP (e.g. "shield-jer")
  $Port = "3128"
  $Network = "ericom.local"
  $PAC_file = "" # Set the URL to the PAC File (e.g. "http://shield-jer/shield.pac")
 
# settings are configured by parsing the right values to the Configure-Proxy function.
  if ( $NetworkConfig.suffix -eq "$Network" )
  {
     $ProxyEnabled = Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyEnable
     if ( $ProxyEnabled.ProxyEnable -eq 0 )
     {   
       # If used as a service, need to be disabled    
       $msgBoxInput =  [System.Windows.MessageBox]::Show('You are at the office in Network. Would you like to set the Proxy?','Setting Proxy','YesNo','Info')
       switch  ($msgBoxInput) {
        'Yes' {
              Configure-Proxy $Proxy $Port
         }
        'No' {
         ## Do something
         }
     } 
     }	  
  }
    # If no value applies, disable the proxy configuration.
  else
  {
      Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyEnable -Value 0
      Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name AutoConfigURL -Value ""      
      $wshell = New-Object -ComObject Wscript.Shell
      $wshell.Popup("Proxy Disabled",0,"Done",0x1)
  }
}
 
#    If used as a service, need to be disabled
while( $true ){
  Set-Proxy
  start-sleep -s 60  
}
