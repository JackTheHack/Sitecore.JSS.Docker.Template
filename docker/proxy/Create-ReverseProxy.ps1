try {
    Import-Module WebAdministration

    $iisAppPoolName = "docker-reverse-proxy-app"
    $iisAppPoolDotNetVersion = "v4.0"
    $iisAppName = "docker-reverse-proxy"
    $directoryPath = Get-Item $PSScriptRoot\..\proxy | % { $_.FullName }

    #navigate to the app pools root
    Set-Location -Path IIS:\AppPools\

    #check if the app pool exists
    if (!(Test-Path $iisAppPoolName -pathType container))
    {
        Write-Host "Creating the application pool"

        #create the app pool
        $appPool = New-Item $iisAppPoolName
        $appPool | Set-ItemProperty -Name "managedRuntimeVersion" -Value $iisAppPoolDotNetVersion
    }
    Write-Host "Trying to create the Site"

    #navigate to the sites root
    Set-Location -Path IIS:\Sites\

    #check if the site exists
    if (Test-Path $iisAppName -pathType container)
    {
        Write-Host "Site already exists"
        return
    }

    #create the site
    $iisApp = New-Item $iisAppName -bindings @{protocol="http";bindingInformation=":80:" + $iisAppName} -physicalPath $directoryPath
    $iisApp | Set-ItemProperty -Name "applicationPool" -Value $iisAppPoolName

    Write-Host "Adding Bindings"

    New-WebBinding -Name $iisAppName -IPAddress "*" -Port 443 -Protocol https -HostHeader "jss_cm.dev.docker"
    New-WebBinding -Name $iisAppName -IPAddress "*" -Port 443 -Protocol https -HostHeader "jss_cd.dev.docker"

}
finally {

    Write-Host "Done"
}