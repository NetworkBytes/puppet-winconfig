
define winconfig::loopback_check (
  $ensure,
) {

  include winconfig::params
  validate_re($ensure, '^(present|enabled|absent|disabled)$', 'valid values for ensure are \'present\', \'enabled\', \'absent\', \'disabled\'')

  $data = $ensure ? { /(present|enabled)/ => 1, /(absent|disabled)/ => 0}

  $regbase   = 'HKLM\System\CurrentControlSet\Control\Lsa'
  registry_value { "$regbase\\DisableLoopbackCheck": type => dword, data => "$data"}

}
