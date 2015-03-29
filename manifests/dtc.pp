
define winconfig::dtc (

  $allowonlysecurerpccalls = "0",
  $turnoffrpcsecurity = "1",

  $networkdtcaccess = "1",
  $networkdtcaccessadmin = "1",
  $networkdtcaccessclients = "1",
  $networkdtcaccessinbound = "1",
  $networkdtcaccessoutbound = "1",
  $networkdtcaccesstransactions = "1",
  $xatransactions = "1",

) {
  include winconfig::params

  $regbase   = 'HKLM\SOFTWARE\Microsoft\MSDTC'
  registry_value { "$regbase\\AllowOnlySecureRpcCalls": type => dword, data => "$allowonlysecurerpccalls"}
  registry_value { "$regbase\\TurnOffRpcSecurity":  	type => dword, data => "$turnoffrpcsecurity"}


  registry_value { "$regbase\\Security\\NetworkDtcAccess":  		type => dword, data => "$networkdtcaccess"}
  registry_value { "$regbase\\Security\\NetworkDtcAccessAdmin":  	type => dword, data => "$networkdtcaccessadmin"}
  registry_value { "$regbase\\Security\\NetworkDtcAccessClients": 	type => dword, data => "$networkdtcaccessclients"}
  registry_value { "$regbase\\Security\\NetworkDtcAccessInbound":  	type => dword, data => "$networkdtcaccessinbound"}
  registry_value { "$regbase\\Security\\NetworkDtcAccessOutbound":  	type => dword, data => "$networkdtcaccessoutbound"}
  registry_value { "$regbase\\Security\\NetworkDtcAccessTransactions":  type => dword, data => "$networkdtcaccesstransactions"}
  registry_value { "$regbase\\Security\\XaTransactions":  		type => dword, data => "$xatransactions"}

}

