
define winconfig::webserver (
  $ensure,
  $sslv2_enabled = 0,
) {

  include winconfig::params
  validate_re($ensure, '^(present|enabled|absent|disabled)$', 'valid values for ensure are \'present\', \'enabled\', \'absent\', \'disabled\'')
  $_install_ensure = $ensure ? { /(present|enabled)/ => 'present', /(absent|disabled)/ => 'absent'}


  $features = [
    "Web-Server",
    "Web-ASP",
    "Web-Filtering",
    "Web-ISAPI-Ext",
    "Web-ASP-Net",
    "Web-Net-Ext",
    "Web-ISAPI-Filter",
    "Web-Basic-Auth",
    "Web-Windows-Auth",
    "Web-Dyn-Compression",
    "Web-Http-Tracing",
    "Web-Log-Libraries",
    "Web-Mgmt-Compat",
    "Web-Mgmt-Service",
    "Web-Scripting-Tools",
    "AS-Web-Support",


  ]
  
  winconfig::feature {$features: ensure => "$_install_ensure", restart => true}



  $regbase = 'HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server'
  registry_value { "$regbase\\Enabled": type => dword, data => "$sslv2_enabled"}

}



#REM TODO - Non Rerunable - Configuring custom settings and MIME Types

#%APPCMD% set config -section:urlCompression /doStaticCompression:True
#%APPCMD% set config -section:urlCompression /doDynamicCompression:True
#%APPCMD% set config -section:httpCompression -[name='gzip'].staticCompressionLevel:9
#%APPCMD% set config -section:httpCompression -[name='gzip'].dynamicCompressionLevel:9

#%APPCMD% set config -section:system.webServer/httpCompression /+"dynamicTypes.[mimeType='application/json',enabled='True']" /commit:apphost
#%APPCMD% set config -section:system.webServer/httpCompression /+"dynamicTypes.[mimeType='application/json; charset=utf-8',enabled='True']" /commit:apphost

#%APPCMD% set config -section:httpProtocol /-customHeaders.[name='X-Powered-By']
#%APPCMD% set config -section:httpProtocol /+customHeaders.[name='Etag',value='']


#http://forums.iis.net/t/1188986.aspx
