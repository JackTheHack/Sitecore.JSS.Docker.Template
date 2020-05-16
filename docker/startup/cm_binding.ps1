[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$EntryPointScriptPath = "C:\tools\entrypoints\iis\Development.ps1"
)

Write-Host "Running startup.ps1"
Import-Module WebAdministration
try{

    #https://sitecore.stackexchange.com/questions/24550/error-viewing-jss-app-item-has-already-been-added-key-in-dictionary-psmodule
    copy-item "C:\startup\ServiceMonitor.exe" -Destination "C:\ServiceMonitor.exe" -Force

    New-WebBinding -Name "Default Web Site" -Protocol http -IPAddress * -Port 44001 -HostHeader "jss_cm.cm.docker"
    New-WebBinding -Name "Default Web Site" -Protocol http -IPAddress * -Port 44004 -HostHeader "jss_cm.cm.docker"


}catch{
Write-Host "Failed to add binding."
}

Write-Host "Running $($EntryPointScriptPath)"
& $EntryPointScriptPath