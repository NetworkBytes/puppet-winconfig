# Windows Configuration Base Parameters
class winconfig::params{

  # ensure windows os
  if $::operatingsystem != 'windows'{
    fail("Unsupported OS ${::operatingsystem}")
  }
  if versioncmp("$::operatingsystemrelease", "6.0") < 0 {  
      fail('Windows 2003 is not supported...')
  } else {
      info('Operating System is Windows 2008 or newer.  Proceeding...')
  }

   Registry_value {
      ensure => present,
      type   => string,
   }

   Exec {
      path => 'C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Program Files (x86)\Puppet Labs\Puppet Enterprise\bin;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Windows\System32\WindowsPowerShell\v1.0\;',
      logoutput=> true,
   }


}
