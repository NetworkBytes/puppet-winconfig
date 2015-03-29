#Windows Proxy Settings
class winconfig::proxy (
  $ensure=undef,
  $proxyserver=undef,
  $proxyoverride=undef,
  $proxysettingsperuser="1",
){
   include winconfig::params


   $regbase   = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings'

   case $ensure {
      'present','enabled': 
      {
         $proxy_enable = 1

         registry_value { "$regbase\\ProxyServer":   data => "$proxyserver"}
         registry_value { "$regbase\\ProxyOverride": data => join($proxyoverride,";")}

         registry_value { "32:$regbase\\ProxyServer":  data => "$proxyserver"}
         registry_value { "32:$regbase\\ProxyOverride": data => join($proxyoverride,";")}

         $policy = "HKLM\\SOFTWARE\\Policies\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\ProxySettingsPerUser"
         registry_value { "$policy": type => dword, data => "$proxysettingsperuser"}
         registry_value { "32:$policy": type => dword, data => "$proxysettingsperuser"}

         registry_value {    "$regbase\\AutoConfigURL": ensure => absent }
         registry_value { "32:$regbase\\AutoConfigURL": ensure => absent }


         winhttp_proxy { 'proxy': ensure => present, proxy_server => $proxyserver, bypass_list  => $proxyoverride}


      }

      'absent','disabled': 
      {
         $proxy_enable = 0 
         winhttp_proxy { 'proxy': ensure => absent}
      }
      default: { fail('You must specify ensure status...') }
   }


   registry_value {   "$regbase\\ProxyEnable": type => dword, data => "$proxy_enable"}
   registry_value {"32:$regbase\\ProxyEnable": type => dword, data => "$proxy_enable"}

} 
