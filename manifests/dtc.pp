
define winconfig::dtc (

  $AllowOnlySecureRpcCalls = "0",
  $TurnOffRpcSecurity = "1",

  $NetworkDtcAccess = "1",
  $NetworkDtcAccessAdmin = "1",
  $NetworkDtcAccessClients = "1",
  $NetworkDtcAccessInbound = "1",
  $NetworkDtcAccessOutbound = "1",
  $NetworkDtcAccessTransactions = "1",
  $XaTransactions = "1",

) {
  include winconfig::params

  $regbase   = 'HKLM\SOFTWARE\Microsoft\MSDTC'
  registry_value { "$regbase\\AllowOnlySecureRpcCalls":  type => dword, data => "$AllowOnlySecureRpcCalls"}
  registry_value { "$regbase\\TurnOffRpcSecurity":  type => dword, data => "$TurnOffRpcSecurity"}


  registry_value { "$regbase\\Security\\NetworkDtcAccess":  type => dword, data => "$NetworkDtcAccess"}
  registry_value { "$regbase\\Security\\NetworkDtcAccessAdmin":  type => dword, data => "$NetworkDtcAccessAdmin"}
  registry_value { "$regbase\\Security\\NetworkDtcAccessClients":  type => dword, data => "$NetworkDtcAccessClients"}
  registry_value { "$regbase\\Security\\NetworkDtcAccessInbound":  type => dword, data => "$NetworkDtcAccessInbound"}
  registry_value { "$regbase\\Security\\NetworkDtcAccessOutbound":  type => dword, data => "$NetworkDtcAccessOutbound"}
  registry_value { "$regbase\\Security\\NetworkDtcAccessTransactions":  type => dword, data => "$NetworkDtcAccessTransactions"}
  registry_value { "$regbase\\Security\\XaTransactions":  type => dword, data => "$XaTransactions"}

}

