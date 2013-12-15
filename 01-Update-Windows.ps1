# http://boxstarter.org/package/url?

#####################
# BEGIN CONFIGURATION
#####################

#region Initial Windows Config
 
    Install-WindowsUpdate -AcceptEula
    Update-ExecutionPolicy Unrestricted
    Set-ExplorerOptions -showFileExtensions
    Enable-RemoteDesktop
 
#endregion

#region Add some windows extras
    cinst IIS-WebServerRole -source windowsfeatures
    cinst TelnetClient -source windowsFeatures
    cinst IIS-HttpCompressionDynamic -source windowsfeatures
    cinst IIS-ManagementScriptingTools -source windowsfeatures
    cinst IIS-WindowsAuthentication -source windowsfeatures
#endregion


# Let's get the latest version of powershell and .net frameworks
cinstm PowerShell
cinstm DotNet4.0
cinstm DotNet4.5
cinstm mono