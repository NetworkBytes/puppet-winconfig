
define winconfig::uac (
  $ensure,
) {
  include winconfig::params

  validate_re($ensure, '^(present|enabled|absent|disabled)$', 'valid values for ensure are \'present\', \'enabled\', \'absent\', \'disabled\'')
  
  $data = $ensure ? { /(present|enabled)/ => 1, /(absent|disabled)/ => 0}


  $regbase   = 'HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System'
  registry_value { "$regbase\\EnableLUA":  type => dword, data => "$data"}

  reboot { 'reboot_after_uac':
    subscribe => Registry::Value["$regbase\\EnableLUA"],
    apply  => finished,
  }
}
