#Windows SNMP management
define winconfig::snmp (
  $ensure,
  $contact = "",
  $location= "",
  $community,
  $permittedmanagers
) {

  include winconfig::params
  validate_re($ensure, '^(present|enabled|absent|disabled)$', 'valid values for ensure are \'present\', \'enabled\', \'absent\', \'disabled\'')
  $_install_ensure = $ensure ? { /(present|enabled)/ => 'present', /(absent|disabled)/ => 'absent'}

  
  $perm_write=8
  $perm_read=4
  $perm_none=1

  winconfig::feature {"SNMP-Services": ensure => "$_install_ensure"}

  $regbase   = 'HKLM\system\CurrentControlSet\Services\SNMP\Parameters'

  registry_value { "$regbase\\ValidCommunities\\$community": type => dword, data => "$perm_read"}

  # Contacts
  registry_value { "$regbase\\RFC1156Agent\\sysContact":  data => "$contact"}
  registry_value { "$regbase\\RFC1156Agent\\sysLocation": data => "$location"}
  registry_value { "$regbase\\RFC1156Agent\\sysServices": type => dword,  data => "79"} #all services

  #TODO remove any other permitted managers and implement array
  registry_value { "$regbase\\PermittedManagers\\1": data => "$permittedmanagers"}


  $regkeys = [
    Registry_value ["$regbase\\ValidCommunities\\$community"],
    Registry_value ["$regbase\\RFC1156Agent\\sysContact"],
    Registry_value ["$regbase\\RFC1156Agent\\sysLocation"],
    Registry_value ["$regbase\\RFC1156Agent\\sysServices"],
    Registry_value ["$regbase\\PermittedManagers\\1"],
  ]

  service {'SNMP':
    ensure => running,
    enable => true,
    subscribe => [$regkeys, Winconfig::Feature ["SNMP-Services"]]
  }

}

