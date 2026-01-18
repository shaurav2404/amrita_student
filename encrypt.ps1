
$TenantId     = "280cb568-4692d174"
$ClientId     = "280ab689-11566b8ef"
$ClientSecret = "xgw8Q~Y_AVEt4yDNN3Ur."

$TenantId     | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Set-Content ".\tenantid.enc"
$ClientId     | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Set-Content ".\clientid.enc"
$ClientSecret | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Set-Content ".\clientsecret.enc"
