
Get-Service | Where-Object {$_.StartTime -gt (Get-Date).AddHours(-1)}