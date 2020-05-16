Param(
    $WildCardDomain = "*.docker",
    $RootDomain = "docker",
    $WildCardCertName = "DO NOT TRUST Sitecore Local Development dev.local"
)
process {
    # Generate SSL cert
    $existingCert = Get-ChildItem Cert:\LocalMachine\Root | Where FriendlyName -eq $WildCardCertName
    if(!($existingCert))
    {
        Write-Host "Creating & trusting an new SSL Cert for $WildCardCertName"
 
        # Generate a cert
        # https://docs.microsoft.com/en-us/powershell/module/pkiclient/new-selfsignedcertificate?view=win10-ps
        $cert = New-SelfSignedCertificate -FriendlyName $WildCardCertName -Subject $RootDomain -DnsName $RootDomain,$WildCardDomain -CertStoreLocation "cert:\LocalMachine\My" -Type SSLServerAuthentication -NotAfter (Get-Date).AddYears(10)
        Export-Certificate -Cert $cert -FilePath "$PSScriptRoot\$RootDomain.cer"
        Import-Certificate -Filepath "$PSScriptRoot\$RootDomain.cer" -CertStoreLocation "cert:\LocalMachine\Root"
    }
}