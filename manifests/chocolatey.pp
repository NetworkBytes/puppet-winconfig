class winconfig::chocolatey {

  exec { "install-chocolatey":
    creates => 'C:\ProgramData\Chocolatey',
    provider => 'powershell',
    logoutput => true,
    command => 'iex -Verbose -Debug ((new-object net.webclient).DownloadString(\'https://chocolatey.org/install.ps1\'))',
  }

}

