#Windows Proxy Settings
define winconfig::proxy (
  $ensure=undef,
  $proxyserver=undef,
  $proxyoverride=undef,
  $proxysettingsperuser="0",
){
   include winconfig::params


   $regbase   = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings'

   Registry_value {
      ensure => present,
      type   => string,
   }

   
   case $ensure {
      'present','enabled': 
      {
         $proxy_enable = 1


         registry_value { "$regbase\\ProxyServer":   data => "$proxyserver"}
         registry_value { "$regbase\\ProxyOverride": data => "$proxyoverride"}

         registry_value { "32:$regbase\\ProxyServer":  data => "$proxyserver"}
         registry_value { "32:$regbase\\ProxyOverride": data => "$proxyoverride"}

         $policy = "HKLM\\SOFTWARE\\Policies\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\ProxySettingsPerUser"
         registry_value { "$policy": type => dword, data => "0"}
         registry_value { "32:$policy": type => dword, data => "0"}

      }

      'absent','disabled': 
      {
         $proxy_enable = 0 
      }
      default: { fail('You must specify ensure status...') }



      registry_value { "$regbase\\ProxyEnable":  type => dword, data => "$proxy_enable"}
      registry_value { "32:$regbase\\ProxyEnable": type => dword, data => "$proxy_enable"}


   }

} 
