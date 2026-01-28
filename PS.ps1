function Restart-ServiceSafe {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ServiceName
    )

    try {
        $service = Get-Service -Name $ServiceName -ErrorAction Stop

        if ($service.Status -eq 'Running') {
            Restart-Service -Name $ServiceName -Force
            return "Service '$ServiceName' was running and has been restarted."
        }
        elseif ($service.Status -eq 'Stopped') {
            Start-Service -Name $ServiceName
            return "Service '$ServiceName' was stopped and has been started."
        }

 }
    catch {
        return "Service '$ServiceName' does not exist or cannot be accessed."
    }
}

Restart-ServiceSafe