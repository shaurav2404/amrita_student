# ==============================
# CONFIGURATION
# ==============================
$CPUThreshold = 85
$MemoryThreshold = 80
$DiskThreshold = 20   # Free space %

$ReportPath = "C:\HealthReport.html"

# ==============================
# FUNCTION: CPU USAGE
# ==============================
function Get-CPUUsage {
    $cpu = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
    return [math]::Round($cpu,2)
}

# ==============================
# FUNCTION: MEMORY USAGE
# ==============================
function Get-MemoryUsage {
    $os = Get-CimInstance Win32_OperatingSystem
    $used = (($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) * 100) / $os.TotalVisibleMemorySize
    return [math]::Round($used,2)
}

# ==============================
# FUNCTION: DISK USAGE
# ==============================
function Get-DiskUsage {
    $disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"
    $result = @()

    foreach ($disk in $disks) {
        $freePercent = ($disk.FreeSpace / $disk.Size) * 100
        $result += [PSCustomObject]@{
            Drive = $disk.DeviceID
            FreePercent = [math]::Round($freePercent,2)
        }
    }
    return $result
}

# ==============================
# FUNCTION: SERVICE STATUS
# ==============================
function Get-CriticalServices {
    $services = "wuauserv","WinDefend","Spooler"

    Get-Service -Name $services | Select-Object Name, Status
}

# ==============================
# FUNCTION: EVENT LOG ERRORS
# ==============================
function Get-RecentErrors {
    Get-WinEvent -LogName System -MaxEvents 50 |
    Where-Object { $_.LevelDisplayName -eq "Error" } |
    Select-Object TimeCreated, Id, Message -First 5
}

# ==============================
# FUNCTION: ALERT CHECK
# ==============================
function Check-Alerts {
    param($cpu, $memory, $diskData, $services)

    $alerts = @()

    if ($cpu -gt $CPUThreshold) {
        $alerts += "High CPU Usage: $cpu %"
    }

    if ($memory -gt $MemoryThreshold) {
        $alerts += "High Memory Usage: $memory %"
    }

    foreach ($disk in $diskData) {
        if ($disk.FreePercent -lt $DiskThreshold) {
            $alerts += "Low Disk Space on $($disk.Drive): $($disk.FreePercent)% free"
        }
    }

    foreach ($svc in $services) {
        if ($svc.Status -ne "Running") {
            $alerts += "Service Stopped: $($svc.Name)"
        }
    }

    return $alerts
}

# ==============================
# FUNCTION: GENERATE HTML REPORT
# ==============================
function Generate-HTMLReport {
    param($cpu, $memory, $disk, $services, $errors, $alerts)

    $html = @"
<html>
<head>
<title>Endpoint Health Report</title>
<style>
body { font-family: Arial; }
table { border-collapse: collapse; width: 80%; }
th, td { border: 1px solid black; padding: 8px; }
th { background-color: #f2f2f2; }
.alert { color: red; font-weight: bold; }
</style>
</head>
<body>

<h2>Endpoint Health Report</h2>

<h3>System Metrics</h3>
<p>CPU Usage: $cpu %</p>
<p>Memory Usage: $memory %</p>

<h3>Disk Status</h3>
<table>
<tr><th>Drive</th><th>Free %</th></tr>
"@

    foreach ($d in $disk) {
        $html += "<tr><td>$($d.Drive)</td><td>$($d.FreePercent)</td></tr>"
    }

    $html += "</table>"

    $html += "<h3>Services</h3><table><tr><th>Name</th><th>Status</th></tr>"
    foreach ($s in $services) {
        $html += "<tr><td>$($s.Name)</td><td>$($s.Status)</td></tr>"
    }
    $html += "</table>"

    $html += "<h3>Recent Errors</h3><ul>"
    foreach ($e in $errors) {
        $html += "<li>$($e.TimeCreated) - $($e.Id)</li>"
    }
    $html += "</ul>"

    $html += "<h3>Alerts</h3>"
    if ($alerts.Count -eq 0) {
        $html += "<p>No issues detected</p>"
    } else {
        foreach ($a in $alerts) {
            $html += "<p class='alert'>$a</p>"
        }
    }

    $html += "</body></html>"

    $html | Out-File $ReportPath
}

# ==============================
# MAIN FUNCTION
# ==============================
function Start-HealthCheck {

    Write-Host "Starting Endpoint Health Check..."

    $cpu = Get-CPUUsage
    $memory = Get-MemoryUsage
    $disk = Get-DiskUsage
    $services = Get-CriticalServices
    $errors = Get-RecentErrors

    $alerts = Check-Alerts -cpu $cpu -memory $memory -diskData $disk -services $services

    Generate-HTMLReport -cpu $cpu -memory $memory -disk $disk -services $services -errors $errors -alerts $alerts

    Write-Host "Health Check Completed. Report saved at $ReportPath"
}

# ==============================
# EXECUTE
# ==============================
Start-HealthCheck