
define winconfig::feature (
    $ensure = 'present',
    $feature_name = $title,
    $installmanagementtools = false,
    $installsubfeatures = false,
    $restart = false
) {

  #based from opentable::windowsfeature
  include winconfig::params


  validate_re($ensure, '^(present|absent)$', 'valid values for ensure are \'present\' or \'absent\'')
  validate_bool($installmanagementtools)
  validate_bool($installsubfeatures)
  validate_bool($restart)


  #if $::operatingsystem != 'windows' { fail ("${module_name} not supported on ${::operatingsystem}") }
  if $::kernelversion =~ /^6.0/ {
    # Windows 2008 (non R2), use ServerManagerCMD.exe
    if $restart { $_restart = ' -restart ' } else { $_restart = '' }
    if $installsubfeatures { $_installsubfeatures = '-allSubFeatures' }
  } else {
    if $restart { $_restart = true } else { $_restart = false }
    if $installsubfeatures { $_installsubfeatures = '-IncludeAllSubFeature' }
  }


  if $::kernelversion =~ /^(6.1)/ and $installmanagementtools {
    fail ('Windows 2012 or newer is required to use the installmanagementtools parameter')
  } elsif $installmanagementtools {
    $_installmanagementtools = '-IncludeManagementTools'
  }

  if(is_array($feature_name)){
    if $::kernelversion =~ /^6.0/ {fail("Uninstall Windows Feature failed: Error, arrays not supported on ${::operatingsystem}}")}
    $escaped = join(prefix(suffix($feature_name,'\''),'\''),',')
    $features = "@(${escaped})"
  }else{
    $features = $feature_name
  }

  # Windows 2008 R2 and newer required http://technet.microsoft.com/en-us/library/ee662309.aspx
  if $::kernelversion !~ /^(6\.0|6\.1|6\.2|6\.3)/ { fail ("${module_name} requires Windows 2008 or newer") }



  # from Windows 2012 'Add-WindowsFeature' has been replaced with 'Install-WindowsFeature' http://technet.microsoft.com/en-us/library/ee662309.aspx
  if ($ensure == 'present') {

    if $::kernelversion =~ /^6.0/ {
      exec { "add-feature-${title}":
        command   => "ServerManagerCmd.exe -install ${features} ${_installsubfeatures} ${_restart}",
        path      => "$path;c:\\windows\\sysnative;",
        unless    => "cmd /c servermanagercmd -query |findstr /C:\"[${features}]\" |findstr /C:\"[X]\"",
      }
    } else {
      if $::kernelversion =~ /^(6.1)/ { $command = 'Add-WindowsFeature' } else { $command = 'Install-WindowsFeature' }
      exec { "add-feature-${title}":
        command   => "Import-Module ServerManager; ${command} ${features} ${_installmanagementtools} ${_installsubfeatures} -Restart:$${_restart}",
        onlyif    => "Import-Module ServerManager; if (@(Get-WindowsFeature ${features} | ?{\$_.Installed -match \'false\'}).count -eq 0) { exit 1 }",
        provider  => powershell
      }
    }

  } elsif ($ensure == 'absent') {

    if $::kernelversion =~ /^6.0/ {
      exec { "add-feature-${title}":
        command   => "ServerManagerCmd.exe -remove ${features} ${_installsubfeatures} ${_restart}",
        path      => "$path;c:\\windows\\sysnative;",
        onlyif    => "cmd /c servermanagercmd -query |findstr /C:\"[${features}]\" |findstr /C:\"[X]\"",
      }

    } else {

      exec { "remove-feature-${title}":
        command   => "Import-Module ServerManager; Remove-WindowsFeature ${features} -Restart:$${_restart}",
        onlyif    => "Import-Module ServerManager; if (@(Get-WindowsFeature ${features} | ?{\$_.Installed -match \'true\'}).count -eq 0) { exit 1 }",
        provider  => powershell
      }
    }
  }
}
