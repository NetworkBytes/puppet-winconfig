#User Access Control management

define winconfig::hibernate (
  $ensure,
) {
  include winconfig::params

  case $ensure {
    'present','enabled': { $data = 1 }
    'absent','disabled': { $data = 0 }
    default: { fail('You must specify ensure status...') }
    }
  }


  $regbase   = 'HKLM\SYSTEM\CurrentControlSet\Control\Power'
  registry_value { "$regbase\\HiberFileSizePercent":  type => dword, data => "$data"}
  registry_value { "$regbase\\HibernateEnabled":  type => dword, data => "$data"}

  reboot { 'after_hibernate_disabled':
    subscribe  => [ Registry_value["$regbase\\HiberFileSizePercent"],
                    Registry_value["$regbase\\HibernateEnabled"]
                  ],
    apply  => finished,
   }
}

