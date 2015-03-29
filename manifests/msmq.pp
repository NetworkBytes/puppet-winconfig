
define winconfig::msmq (
  $ensure = present,
  $permitanoneveryonesend=1,
  $ignoreosnamevalidation=1,
) {
  include winconfig::params

  validate_re($ensure, '^(present|absent)$', 'valid values for ensure are \'present\' or \'absent\'')
  validate_re("$permitanoneveryonesend", '^(0|1)$', 'valid values for permitanoneveryonesend are \'0\' or \'1\'')
  validate_re("$ignoreosnamevalidation", '^(0|1)$', 'valid values for ignoreosnamevalidation are \'0\' or \'1\'')


  $regbase = 'HKLM\SOFTWARE\Microsoft\MSMQ\Parameters'

  registry_value { "$regbase\\Security\\PermitAnonEveryoneSend": type => dword, data => "$permitanoneveryonesend"}
  registry_value { "$regbase\\IgnoreOSNameValidation":           type => dword, data => "$ignoreosnamevalidation"}


  winconfig::feature {"MSMQ": restart => true, ensure => "$ensure"}

}
