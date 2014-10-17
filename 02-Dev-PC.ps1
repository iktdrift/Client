# http://boxstarter.org/package/url?

    # Screenshot tool
    cinstm greenshot

    # It's nice to be able to browse NuGet files if necessary
    cinstm NugetPackageExplorer

    # If we're doing web development, we need a few browsers
    cinstm GoogleChrome
    cinstm Firefox
    cinstm Opera

    # Don't quite know why this is important, but I'll install silverlight and java runtime anyways
    cinstm Silverlight
    cinstm javaruntime
    
    # Gotta have Fiddler
    cinstm fiddler4

    # Editors and merge tools
    cinstm notepadplusplus.install
    cinstm nano
    cinst sublimetext2
    
    # Without Git, we might as well go home.
    cinstm poshgit
    cinstm git-credential-winstore -Version 1.2.0.0

    # Life sux without Visual Studio and the awesome extensions
    cinstm VisualStudio2012Professional
    
    # Get rid of upper case menu in Visual Studio
    Set-ItemProperty -Path HKCU:\Software\Microsoft\VisualStudio\11.0\General -Name SuppressUppercaseConversion -Type DWord -Value 1 

    # Run Visual Studio Update
    if((Get-Item "$($Boxstarter.programFiles86)\Microsoft Visual Studio 11.0\Common7\IDE\devenv.exe").VersionInfo.ProductVersion -lt "11.0.60115.1") {
        if(Test-PendingReboot){Invoke-Reboot}
        Install-ChocolateyPackage 'vs update 2 ctp2' 'exe' '/passive /norestart' 'http://download.microsoft.com/download/8/9/3/89372D24-6707-4587-A7F0-10A29EECA317/vsupdate_KB2707250.exe'
    }

    # VS related extras
    cinstm resharper

    # Fix SSH-Agent error by adding the bin directory to the `Path` environment variable
    $env:PSModulePath = $env:PSModulePath + ";C:\Program Files (x86)\Git\bin"

    # Markdown is how documentation becomes awesomenes
    # Unfortunately I'm installing this at the end because it doesn't seem to work unattended... it requires the user to press "ok"
    cinstm MarkdownPad2 -installargs "/exelang 1033"
    
    # VPN Client 
    # cinstm ShrewSoftVpn
    
    # Sql Server
    cinst SqlServer2012Express
