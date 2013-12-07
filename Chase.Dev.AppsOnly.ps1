$invocation = (Get-Variable MyInvocation).Value
$currentDirectory = Split-Path $invocation.MyCommand.Path

#endregion

#region Setup user environment

    # Create a Skydrive directory this will be the new user home directory
    # this is being done early in the process so that it can be used to store 
    # the boxstarter-settings.xml document
    if(!(Test-Path -PathType Container $Home\SkyDrive\Documents)){
        Write-Host "Creating a SkyDrive directory for use as $env:username`'s Documents folder."
        New-Item "$HOME\SkyDrive\Documents" -type Directory
    } 

    # Move the Library directory to Skydrive
    Move-LibraryDirectory "Personal" "$HOME\SkyDrive\Documents"


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

#region Install Apps via Chocolatey `> cinstm appname`

    # Let's get the latest version of powershell and .net frameworks
    cinstm PowerShell
    cinstm DotNet4.0
    cinstm DotNet4.5

    # It's nice to be able to browse NuGet files if necessary
    cinstm NugetPackageExplorer

    # If we're doing web development, we need a few browsers
    cinstm GoogleChrome
    cinstm Firefox
    cinstm Opera

    # Don't quite know why this is important, but I'll install silverlight and java runtime anyways
    cinstm Silverlight
    cinstm javaruntime

    # Skydrive is a must for sync'ed data. Prefered over Dropbox IMO
    cinstm skydrive
    cinstm evernote
    
    # Gotta have Fiddler
    cinstm fiddler4

    # Editors and merge tools
    cinstm notepadplusplus.install
    cinstm nano
    
    # Without Git, we might as well go home.
    cinstm poshgit
    cinstm git-credential-winstore

    # Life sux without Visual Studio and the awesome extensions
    cinstm VisualStudio2012Professional

    # Run Visual Studio Update
    if((Get-Item "$($Boxstarter.programFiles86)\Microsoft Visual Studio 11.0\Common7\IDE\devenv.exe").VersionInfo.ProductVersion -lt "11.0.60115.1") {
        if(Test-PendingReboot){Invoke-Reboot}
        Install-ChocolateyPackage 'vs update 2 ctp2' 'exe' '/passive /norestart' 'http://download.microsoft.com/download/8/9/3/89372D24-6707-4587-A7F0-10A29EECA317/vsupdate_KB2707250.exe'
    }

    # VS related extras
    cinstm resharper -Version 7.1.3000.2254 # I don't currently have a R# v.8 license.
    Install-ChocolateyVsixPackage "vscommands" http://visualstudiogallery.msdn.microsoft.com/a83505c6-77b3-44a6-b53b-73d77cba84c8/file/74740/18/SquaredInfinity.VSCommands.VS11.vsix 11
    Install-ChocolateyVsixPackage "NuGet Package Manager" http://visualstudiogallery.msdn.microsoft.com/27077b70-9dad-4c64-adcf-c7cf6bc9970c/file/37502/33/NuGet.Tools.vsix 11
    Install-ChocolateyVsixPackage "Console Launcher" http://visualstudiogallery.msdn.microsoft.com/1460ab21-75be-49d0-900f-dfd538321424/file/54475/11/ConsoleLauncher.vsix 11
    Install-ChocolateyVsixPackage "TextHighlighterExtension2012" http://visualstudiogallery.msdn.microsoft.com/fd129629-a1a1-417c-ac80-c9ac7a67b968/file/93334/9/TextHighlighterExtension2012.vsix 11

    # Fix SSH-Agent error by adding the bin directory to the `Path` environment variable
    Add-PathEnvironmentVariable "C:\Program Files (x86)\Git\bin"

# Markdown is how documentation becomes awesomenes
# Unfortunately I'm installing this at the end because it doesn't seem to work unattended... it requires the user to press "ok"
cinstm MarkdownPad2 -installargs "/exelang 1033"
