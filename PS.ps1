function Get-ServiceStatus {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ServiceName
    )
    try {
     
           $service = Get-Service -Name $ServiceName -ErrorAction Stop
    
    if ($service.Status -eq "Running") 
    {
        return "Service '$ServiceName' is running." 
    }
    else 
    {
        return "Service '$ServiceName' is not running."
    }
    }
    catch 
    {
        return "Service '$ServiceName' not found."
    }
    
}
Get-ServiceStatus