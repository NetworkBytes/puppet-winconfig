
define winconfig::smb_security_signature (
  $ensure,
) {
  include winconfig::params
  case $ensure {
    'present','enabled': { $data = 1 }
    'absent','disabled': { $data = 0 }
    default: { fail('You must specify ensure status...') }
  }

  $regbase   = 'HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters'
  registry_value { "$regbase\\RequireSecuritySignature":  type => dword, data => "$data"}

}
