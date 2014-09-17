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
}
