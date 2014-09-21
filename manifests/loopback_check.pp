
define winconfig::loopback_check (
  $ensure,
) {
  include winconfig::params

  case $ensure {
    'present','enabled': { $data = 1 }
    'absent','disabled': { $data = 0 }
    default: { fail('You must specify ensure status...') }
  }


   $regbase   = 'HKLM\System\CurrentControlSet\Control\Lsa'
   registry_value { "$regbase\\DisableLoopbackCheck": type => dword, data => "$data"}

}
