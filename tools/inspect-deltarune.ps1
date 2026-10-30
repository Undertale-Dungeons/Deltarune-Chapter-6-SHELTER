param(
    [Parameter(Position = 0)]
    [string]$GamePath
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($GamePath)) {
    $GamePath = Read-Host "Paste your DELTARUNE install folder path"
}

$GamePath = $GamePath.Trim('"')

if (-not (Test-Path -LiteralPath $GamePath -PathType Container)) {
    Write-Error "Folder not found: $GamePath"
    exit 1
}

$files = Get-ChildItem -LiteralPath $GamePath -Filter "data.win" -File -Recurse -ErrorAction SilentlyContinue

if (-not $files) {
    Write-Host "No data.win files found under that folder." -ForegroundColor Yellow
    Write-Host "Select the DELTARUNE install folder, not the saves folder."
    exit 2
}

Write-Host ""
Write-Host "DELTARUNE local file report" -ForegroundColor Cyan
Write-Host "This script only reads files. It does not modify or upload anything."
Write-Host ""

foreach ($file in $files | Sort-Object FullName) {
    $root = $GamePath.TrimEnd([char[]]"\/")
    $relative = $file.FullName.Substring($root.Length).TrimStart([char[]]"\/")
    $md5 = (Get-FileHash -LiteralPath $file.FullName -Algorithm MD5).Hash.ToLowerInvariant()
    $sha256 = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash.ToLowerInvariant()

    Write-Host "File:   $relative"
    Write-Host "Size:   $($file.Length) bytes"
    Write-Host "MD5:    $md5"
    Write-Host "SHA256: $sha256"
    Write-Host ""
}

Write-Host "Copy the report text into the chat. Do not send the game files." -ForegroundColor Green
