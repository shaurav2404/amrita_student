function Move-Files{
    param (
    [Parameter(Mandatory= $true)][string]$Filename,
    [parameter(Mandatory= $true)][string]$Destination,
    [parameter(Mandatory = $true)][string]$FileType
 
    )
    if (Test-Path $Filename){
        Get-ChildItem -path $Filename -Filter "*.$FileType" -ErrorAction Stop |
        ForEach-Object{
            Move-Item -Path $_.FullName -Destination $Destination -ErrorAction Stop
        }
        return "File moved successfully to $Destination"
    }
    else{
        return "Failed to move the file."
    }
}

Move-Files