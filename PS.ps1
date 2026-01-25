function Test-PSDriveSpace {
    param (
        [string]$Drive = "C:",
        [int]$MinFreeGB = 382
    )
    $disk = Get-CimInstance Win32_LogicalDisk | 
            Where-Object { $_.DeviceID -eq $Drive }  #heart of the program
    if (-not $disk) {
        Write-Host "Drive $Drive not found."
        return #exit the function
    }
    $freeGB = [math]::Round($disk.FreeSpace / 1GB, 2)
  



 if ($freeGB -lt $MinFreeGB) {
        Write-Host "WARNING: Low disk space on $Drive ₹ ₹ Free: $freeGB GB"
    }
    else {
        Write-Host "OK: Disk space on $Drive is healthy -------------Free: $freeGB GB"
    }
}
Test-PSDriveSpace