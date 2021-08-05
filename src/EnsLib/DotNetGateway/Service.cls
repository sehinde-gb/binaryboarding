/* Copyright (c) 2021 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include %occDotNet

/// A service responsible for starting, monitoring and stopping the .NET Gateway Server in a production.
Class EnsLib.DotNetGateway.Service Extends EnsLib.Gateway.Service [ ClassType = "", ProcedureBlock, System = 4 ]
{

/// IP address or name of the machine where the .NET Gateway Server executable is located.
Property DotNetServer As %String [ InitialExpression = "127.0.0.1" ];

/// Which IP address, among the several IP addresses that the machine has, that allows incoming connections.
/// Specify 0.0.0.0 or null to listen on all IP addresses local to the machine (127.0.0.1, VPN address, etc.).
/// You can also specify a single existing local IP address to restrict the listener to that IP address. 
Property AllowedIPAddresses As %String [ InitialExpression = "127.0.0.1" ];

/// On 64-bit platforms, indicates if the Gateway server is to be executed as 32-bit (default) or 64-bit.
Property Exec64 As %Boolean [ InitialExpression = 0 ];

/// .NET version, used to select the intended directory for the target external executable.
Property DotNetVersion As %String(DISPLAYLIST = ",2.0,4.0,4.5,Core2.1", VALUELIST = ",2.0,4.0,4.5,Core2.1") [ InitialExpression = "4.5" ];

/// Location of the .NET Gateway Server executable.
/// It is used to find the target executable and assemble the command to start the .NET Gateway
/// on a local server. <br>
/// If this setting is not specified, the default directory used is ...\Dev\dotnet\bin\ under 
/// the Ensemble installation directory.
Property FilePath As %String(MAXLEN = 1023);

Parameter SETTINGS = "DotNetServer:Basic,Port:Basic,AllowedIPAddresses,Exec64,DotNetVersion,FilePath:Basic,Logfile,UsePassphrase,HeartbeatInterval,HeartbeatFailureTimeout,HeartbeatFailureAction,HeartbeatFailureRetry,-ArchiveIO";

Method ServerGet() As %String
{
	quit ..DotNetServer
}

Method GetObjectGateway() As %Net.Remote.ObjectGateway
{
	Set gatewayDefinition = ##class(%Net.Remote.ObjectGateway).%New()
	Set gatewayDefinition.Type = 2 // DotNet
	Set gatewayDefinition.Server = ..Server
	Set gatewayDefinition.Port = ..Port
	Set gatewayDefinition.LogFile = ..Logfile
	Set gatewayDefinition.UsePassphrase = ..UsePassphrase
	;
	Set gatewayDefinition.FilePath = ..FilePath
	Set gatewayDefinition.Exec64 = ..Exec64
	Set gatewayDefinition.DotNetVersion = ..DotNetVersion
	Set gatewayDefinition.AllowedIPAddresses = ..AllowedIPAddresses
	;
	quit gatewayDefinition
}

/// Start up the .NET Gateway Server.
/// This method is deprecated.
ClassMethod StartGateway(pFilePath As %String, pPort As %String, pAllowedIPAddresses As %String, pLogfile As %String = "", ByRef pDevice As %String = "", pServer As %String = "127.0.0.1", pExec64 As %Boolean = 0, pVersion As %String = "2.0", pUsePassphrase As %Boolean = 0) As %Status [ Deprecated ]
{
	set tSC = $$$OK
	try {
		If (pServer="127.0.0.1") || ($ZCVT(pServer,"l")="localhost") || ($ZCVT(pServer,"l")=$ZCVT($ZU(110),"l")) {
			$$$LOGINFO("Starting .NET Gateway with: FilePath="_pFilePath_", Port="_pPort_", AllowedIPAddresses="_pAllowedIPAddresses_", Logfile="_pLogfile_", 64-bit="_$S(pExec64:"Yes",1:"No")_", Version="_pVersion)
			;
			Set gatewayDefinition = ##class(%Net.Remote.ObjectGateway).%New()
			Set gatewayDefinition.Type = 2 // DotNet
			Set gatewayDefinition.Server = pServer
			Set gatewayDefinition.Port = pPort
			Set gatewayDefinition.LogFile = pLogfile
			Set gatewayDefinition.UsePassphrase = pUsePassphrase
			;
			Set gatewayDefinition.FilePath = pFilePath
			Set gatewayDefinition.Exec64 = pExec64
			Set gatewayDefinition.DotNetVersion = pVersion
			Set gatewayDefinition.AllowedIPAddresses = pAllowedIPAddresses
			;
			Set tSC = ##class(%Net.Remote.Service).StartGatewayObject(gatewayDefinition)
		} else {
			$$$LOGINFO(".NET Server not local to the Ensemble server, won't be started by this service")
		}
	} catch {
		Set tSC = $$$EnsSystemError
	}
	quit tSC
}

/// Shutdown the Gateway.
/// This method is deprecated.
ClassMethod StopGateway(pPort As %String, pServer As %String = "127.0.0.1", pTimeout As %Numeric = 5) As %Status [ Deprecated ]
{
	set tSC = $$$OK
	try {
		if (pServer="127.0.0.1") || ($ZCVT(pServer,"l")="localhost") || ($ZCVT(pServer,"l")=$ZCVT($ZU(110),"l")) {
			Set gatewayDefinition = ##class(%Net.Remote.ObjectGateway).%New()
			Set gatewayDefinition.Server = pServer
			Set gatewayDefinition.Port = pPort
			Set gatewayDefinition.ConnectionTimeout = pTimeout
			set tSC = ##class(%Net.Remote.Service).StopGatewayObject(gatewayDefinition)
		} else {
			$$$LOGINFO("The Gateway Server is not local to the InterSystems IRIS server so it won't be shut down or stopped by this service")
		}
	}
	catch {
		set tSC = $$$SystemError
	}
	quit tSC
}

/// "Ping" the .NET Gateway Server to check if it's alive.
/// This method is deprecated.
ClassMethod PingDotNetGateway(pPort As %String, pServer As %String = "127.0.0.1") As %Status [ Deprecated ]
{
	set tSC = $$$OK
	try {
		$$$catTRACE("connwait","Gateway PING: Invoking ##class(%Net.Remote.Gateway).%Ping("_pServer_", "_pPort_", 4)")
		set tSC = ##class(%Net.Remote.Gateway).%Ping(pServer, pPort, 4)
	} catch {
		set tSC = $$$SystemError
	}
	if $$$ISOK(tSC) {
		$$$catTRACE("connwait","Gateway PING successful")
	} else {
		$$$sysTRACE("Error in Gateway PING: "_$$$StatusDisplayString(tSC))
	}
	quit tSC
}

/// Connect to a running .NET Gateway Server.
/// This method is deprecated.
ClassMethod ConnectGateway(pEndpoint As %String, ByRef pGateway As %Net.Remote.Gateway, pTimeout As %Numeric = 5, pAdditionalPaths As %String = "") As %Status [ Deprecated ]
{
	Set tSC = $$$OK
	
	Try {
		// Create a gateway instance
		Set pGateway = ##class(%Net.Remote.Gateway).%New()
		If '$IsObject(pGateway) Set tSC = %objlasterror Quit
		
		Set tHost = $P(pEndpoint,";",1)
		Set tPort = +$P(pEndpoint,";",2)
		Set tNS = $P(pEndpoint,";",3)
		
		// Appropriate defaults
		If tHost = "" Set tHost = "127.0.0.1"
		If tNS = "" Set tNS = $namespace
		
		// Check port
		If ('tPort) || (tPort'?.N) Set tSC = $$$ERROR($$$EnsErrGeneral, "Invalid or missing port '"_tPort_"'") Quit
		
		$$$sysTRACE($classname()_" invoking %Connect with DotNetServer='"_tHost_"', Port='"_tPort_"', tNamespace='"_tNS_"', Timeout="_pTimeout_", AdditionalPaths="_pAdditionalPaths)
		
		// Convert pAdditionalPaths to %ListOfDataTypes if not null
		If pAdditionalPaths="" {
			Set tPath = ""
		}
		Else {
			Set tPath=##class(%ListOfDataTypes).%New()
			For i = 1:1:$L(pAdditionalPaths,",") {
				Do tPath.Insert($P(pAdditionalPaths,",",i))
			}
		}
		
		// And connect
		Set tSC = pGateway.%Connect(tHost, tPort, tNS, pTimeout, tPath,,,0)
		If 'tSC $$$sysTRACE("Error in %Connect: "_$system.Status.GetOneErrorText(tSC))
	}
	
	Catch {
		Set tSC = $$$EnsSystemError
	}
	
	If $$$ISERR(tSC) && $IsObject(pGateway) {
		Do pGateway.%Disconnect()
		Kill pGateway
	}

	Quit tSC
}

}
