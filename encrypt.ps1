
$TenantId     = "280cb568-d1dc-4a34-b94c-06544692d174"
$ClientId     = "280ab689-1156-4510-8f29-cbfe9566b8ef"
$ClientSecret = "xgw8Q~Y_AVEt4yDNN3UcCbu4FCyop2b515QuMdr."

$TenantId     | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Set-Content ".\tenantid.enc"
$ClientId     | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Set-Content ".\clientid.enc"
$ClientSecret | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Set-Content ".\clientsecret.enc"
