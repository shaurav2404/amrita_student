# ================================
# CONFIG
# ================================
$TenantId = Get-Content ".\tenantid.enc" | ConvertTo-SecureString | `
    ForEach-Object { [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($_)
    )}

$ClientId = Get-Content ".\clientid.enc" | ConvertTo-SecureString | `
    ForEach-Object { [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($_)
    )}

$ClientSecret = Get-Content ".\clientsecret.enc" | ConvertTo-SecureString | `
    ForEach-Object { [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($_)
    )}

# Key Vault details
$KeyVaultName = "APITesttoken"
$SecretName   = "test"
# ================================
# FORCE TLS 1.2
# ================================
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
# ================================
# GET TOKEN
# ================================
$tokenResponse = Invoke-RestMethod `
  -Method POST `
  -Uri "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token" `
  -ContentType "application/x-www-form-urlencoded" `
  -Body "client_id=$ClientId&client_secret=$ClientSecret&scope=https://vault.azure.net/.default&grant_type=client_credentials"
$accessToken = $tokenResponse.access_token
if (-not $accessToken) {
    throw "Failed to acquire token"
}
Write-Host "Token acquired"
# ================================
# FETCH SECRET (HARDCODED URL)
# ================================
$headers = @{
    Authorization = "Bearer $accessToken"
}
$secretResponse = Invoke-RestMethod `
  -Method GET `
  -Uri "https://APITesttoken.vault.azure.net/secrets/test?api-version=7.4" `
  -Headers $headers
# ================================
# OUTPUT SECRET
# ================================
if ($null -eq $secretResponse.value) {
    Write-Error "Secret request succeeded but value was not returned (permission issue)"
    $secretResponse | ConvertTo-Json -Depth 10
    exit 1
}
Write-Host "SECRET VALUE:"
Write-Host $secretResponse.value