Service Fabric Scripts
===

These are Scripts for Service Fabric.

1. A KeyVault Creator with Self-Signed Certificate
---

If you want to have a Secure cluster, you need to type a lot of PowerShell commands
for KeyValut with X509 certificate.
However, for the hackathon/demo purpose, you might use Self-Signed Certificate and
don't want to type a lot of PowerShell commands.

In this case, you can use SignedCertWithKeyVault.ps1.

Usage:

Edit `parameter.json`

```
PS> Login-AzureRmAccount
./SignedCertWithKeyVault.ps1 

---------------------------------------------------------
Done! You've got a KeyVault with Self-Signed Certificate!
---------------------------------------------------------
Source Key vault
/subscriptions/xxxxxxx-xxxxx-xxxxxx6cc9/resourceGroups/IdealKeyGroup/providers/Microsoft.KeyVault/vaults/idealVault
Certificate URL
https://idealvault.vault.azure.net:443/secrets/SfCluster/xxxxxxxxxxxxxxxx963
Cert Thumprint:
XXXXXXXXXXXXXXXXXXXXXXXXXXXXX602
For VSTS:Cluster Endpoint(Default):
https://idealcluster.japaneast.cloudapp.azure.com:19000
For VSTS:Client Certificate:
XXXXXXXXXXX(...base64 strings...)
```

Enjoy

