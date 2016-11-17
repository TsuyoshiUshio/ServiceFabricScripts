# PowerShell command for ServiceFabric Test Cluster.
# please edit the "parameter.json" 
# Before staring this script, please Login-AzureRmAccount first.

# 1. Parsing ParameterJSON
param (
    [string]$ParameterFile = "./parameter.json"
    )
$ParameterJSON = Get-Content -Raw -Path $ParameterFile | ConvertFrom-Json

# 2. Creating a self-signed certificate and add it into your CertStore

$password = ConvertTo-SecureString -String $ParameterJSON.SelfSignedCertificate.password -AsPlainText -Force
New-SelfSignedCertificate -CertStoreLocation Cert:\CurrentUser\My -DnsName $ParameterJSON.SelfSignedCertificate.DnsName  -Provider 'Microsoft Enhanced Cryptographic Provider v1.0' | Export-PfxCertificate -File $ParameterJSON.SelfSignedCertificate.FileName -Password $password

# 3. Creating a KeyVault

New-AzureRmResourceGroup -Name $ParameterJSON.KeyVault.ResourceGroupName -Location $ParameterJSON.KeyVault.Location
New-AzureRmKeyVault -VaultName $ParameterJSON.KeyVault.VaultName -ResourceGroupName $ParameterJSON.KeyVault.ResourceGroupName -Location $ParameterJSON.KeyVault.Location -EnabledForDeployment



# 4. Adding X.509 to the KeyVault

$key = Add-AzureKeyVaultKey -VaultName $ParameterJSON.KeyVault.VaultName -Name $ParameterJSON.KeyVault.KeyName -KeyFilePath $ParameterJSON.SelfSignedCertificate.FileName -KeyFilePassword $password

$certfile = Get-Content -Raw -Path $ParameterJSON.SelfSignedCertificate.FileName
$bytes = [System.IO.File]::ReadAllBytes($certfile.PSPath)
$base64 = [System.Convert]::ToBase64String($bytes)

$jsonBlob = @{
data = $base64
dataType = 'pfx'
password = $ParameterJSON.SelfSignedCertificate.password
} | ConvertTo-Json

$contentBytes = [System.Text.Encoding]::UTF8.GetBytes($jsonBlob)
$content = [System.Convert]::ToBase64String($contentBytes)
$secretValue = ConvertTo-SecureString -String $content -AsPlainText -Force
Set-AzureKeyVaultSecret -VaultName $ParameterJSON.KeyVault.VaultName -Name $ParameterJSON.KeyVault.KeyName -SecretValue $secretValue

# 5. Getting the information


Write-Host "---------------------------------------------------------"
Write-Host "Done! You've got a KeyVault with Self-Signed Certificate!"
Write-Host "---------------------------------------------------------"

Write-Host "Source Key vault"
$vault = Get-AzureRmKeyVault -VaultName $ParameterJSON.KeyVault.VaultName
Write-Output $vault.ResourceId

Write-Host "Certificate URL" 
$vaultSecret = Get-AzureKeyVaultSecret -VaultName $ParameterJSON.KeyVault.VaultName -Name $ParameterJSON.KeyVault.KeyName
Write-Output $vaultSecret.Id
Write-HOST "Cert Thumprint:"
$cert = new-object System.Security.Cryptography.X509Certificates.X509Certificate2 $certfile.PSPath, $password
Write-Output $cert.Thumbprint

