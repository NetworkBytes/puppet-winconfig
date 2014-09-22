
define winconfig::esc(
  $ensure,
) {

  include winconfig::params
  validate_re($ensure, '^(present|enabled|absent|disabled)$', 'valid values for ensure are \'present\', \'enabled\', \'absent\', \'disabled\'')

  $data = $ensure ? { /(present|enabled)/ => 1, /(absent|disabled)/ => 0}


  $regbase   = 'HKLM\Software\Microsoft\Active Setup\Installed Components'
  registry_value { "$regbase\\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}":  type => dword, data => "$data"}

}
