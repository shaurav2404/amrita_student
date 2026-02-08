
param (
    [Parameter(Mandatory = $true)]
    [string]$SourceFolder,

    [Parameter(Mandatory = $true)]
    [string]$DestinationFolder,

    [Parameter(Mandatory = $true)]
    [string]$FileType,

    [Parameter(Mandatory = $true)]
    [string]$ZipFilePath
)

# ============================
# FUNCTION: Move Files
# ============================
function Move-Files {
    param (
        [string]$SourceFolder,
        [string]$Destination,
        [string]$FileType
    )

    if (-not (Test-Path $SourceFolder)) {
        return "Source folder does not exist: $SourceFolder"
    }

    try {
        Get-ChildItem -Path $SourceFolder -Filter "*.$FileType" -File -ErrorAction Stop |
        ForEach-Object {
            Move-Item -Path $_.FullName -Destination $Destination -ErrorAction Stop
        }

        return "File move completed successfully."
    }
    catch {
        return "Failed to move files. Error: $($_.Exception.Message)"
    }
}

# ============================
# FUNCTION: Compress Folder
# ============================
function Compress-Folder {
    param (
        [string]$SourceFolder,
        [string]$ZipDestination
    )

    $zipParent = Split-Path $ZipDestination -Parent

    if (-not (Test-Path $SourceFolder)) {
        return "Source folder does not exist: $SourceFolder"
    }

    if (-not (Test-Path $zipParent)) {
        return "Zip destination folder does not exist: $zipParent"
    }

    try {
        Compress-Archive -Path "$SourceFolder\*" -DestinationPath $ZipDestination -Force -ErrorAction Stop
        return "Folder successfully zipped to $ZipDestination"
    }
    catch {
        return "Failed to zip folder. Error: $($_.Exception.Message)"
    }
}

# ============================
# MAIN EXECUTION
# ============================


$moveResult = Move-Files -SourceFolder $SourceFolder `
                         -Destination $DestinationFolder `
                         -FileType $FileType

Write-Host $moveResult

if ($moveResult -match "successfully") {

    Write-Host "Starting zip operation..."
    $zipResult = Compress-Folder -SourceFolder $DestinationFolder `
                                 -ZipDestination $ZipFilePath

    Write-Host $zipResult
}
else {
    Write-Host "Zip operation skipped due to file move failure."
}
