
define winconfig::hibernate (
  $ensure,
) {

  include winconfig::params
  validate_re($ensure, '^(present|enabled|absent|disabled)$', 'valid values for ensure are \'present\', \'enabled\', \'absent\', \'disabled\'')

  $data = $ensure ? { /(present|enabled)/ => 1, /(absent|disabled)/ => 0}

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

