<#
.SYNOPSIS
    The Sea Life - Register file associations and icons for 12 archive formats (HKCU only, no admin).
.DESCRIPTION
    Writes HKCU directly through the .NET registry API so PS 5.1 and PS 7 behave
    identically. Original values are backed up to
    %LOCALAPPDATA%\The Sea Life\associations-backup.json before any change.
#>
[CmdletBinding()]
param(
    [string]$Root = $PSScriptRoot,
    [switch]$NoIsoMount,
    [switch]$NoBackup
)

$ErrorActionPreference = 'Stop'
$HKCU = [Microsoft.Win32.Registry]::CurrentUser

$exe = Join-Path $Root '7zFM.exe'
$iconDir = Join-Path $Root 'Icons'
if (-not (Test-Path -LiteralPath $exe)) { throw "Cannot find $exe. Use -Root to point at the program folder." }
if (-not (Test-Path -LiteralPath $iconDir)) { throw "Cannot find $iconDir. Use -Root to point at the program folder." }

$map = [ordered]@{
    '7z'   = 'keka_7z.ico'
    'zip'  = 'keka_zip.ico'
    'rar'  = 'keka_rar.ico'
    'tar'  = 'keka_tar.ico'
    'gz'   = 'keka_gz.ico'
    'bz2'  = 'keka_bz2.ico'
    'xz'   = 'keka_xz.ico'
    'cab'  = 'keka_cab.ico'
    'iso'  = 'keka_iso.ico'
    'tgz'  = 'keka_tgz.ico'
    'tbz2' = 'keka_tbz2.ico'
    'txz'  = 'keka_txz.ico'
}

$badProgids = @('ArchiveFolder', 'CompressedFolder', 'CABFolder', 'Windows.IsoFile')

function Set-RegValue {
    param([string]$SubKey, [string]$Name, [string]$Value)
    $k = $HKCU.OpenSubKey($SubKey, $true)
    if ($null -eq $k) { $k = $HKCU.CreateSubKey($SubKey, $true) }
    try { $k.SetValue($Name, $Value, [Microsoft.Win32.RegistryValueKind]::String) }
    finally { if ($null -ne $k) { $k.Close() } }
}

function Remove-RegValue {
    param([string]$SubKey, [string]$Name)
    $k = $HKCU.OpenSubKey($SubKey, $true)
    if ($null -ne $k) {
        try { $k.DeleteValue($Name, $false) } catch { }
        finally { $k.Close() }
    }
}

function Get-DefaultValue {
    param([string]$SubKey)
    $k = $HKCU.OpenSubKey($SubKey, $false)
    if ($null -eq $k) { return $null }
    try { return $k.GetValue('', $null) }
    finally { $k.Close() }
}

function Remove-SubKeyTree {
    param([string]$SubKey)
    try { $HKCU.DeleteSubKeyTree($SubKey, $false) } catch { }
}

$backup = [ordered]@{
    createdAt = (Get-Date).ToString('o')
    root      = $Root
    ext       = [ordered]@{}
}

$done = 0
foreach ($ext in $map.Keys) {
    $icon = Join-Path $iconDir $map[$ext]
    if (-not (Test-Path -LiteralPath $icon)) { Write-Warning "Missing icon $icon, skipping .$ext"; continue }

    $prog    = "7-Zip.$ext"
    $extSub  = "Software\Classes\.$ext"
    $progSub = "Software\Classes\$prog"
    $owSubs  = @(
        "$extSub\OpenWithProgids",
        "Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$ext\OpenWithProgids"
    )

    $shellTypes = @()
    foreach ($owSub in $owSubs) {
        $k = $HKCU.OpenSubKey($owSub, $false)
        if ($null -ne $k) {
            foreach ($bad in $badProgids) {
                if ($null -ne $k.GetValue($bad, $null)) { $shellTypes += ($owSub + '|' + $bad) }
            }
            $k.Close()
        }
    }
    $backup.ext[$ext] = [ordered]@{
        extDefault  = Get-DefaultValue $extSub
        progExisted = ($null -ne $HKCU.OpenSubKey($progSub, $false))
        shellTypes  = $shellTypes
    }

    Set-RegValue $progSub '' ("The Sea Life archive - " + $ext)
    Set-RegValue "$progSub\DefaultIcon" '' ('"' + $icon + '",0')
    Set-RegValue "$progSub\shell\open" 'MUIVerb' 'Open with The Sea Life'
    Set-RegValue "$progSub\shell\open\command" '' ('"' + $exe + '" "%1"')
    Set-RegValue "$progSub\shell\myzip_extract_here" 'MUIVerb' 'Extract here...'
    Set-RegValue "$progSub\shell\myzip_extract_here\command" '' ('"' + $exe + '" "%1"')
    Set-RegValue $extSub '' $prog

    foreach ($owSub in $owSubs) {
        foreach ($bad in $badProgids) { Remove-RegValue $owSub $bad }
    }
    $done++
}

if (-not $NoIsoMount) {
    $shellSub = 'Software\Classes\7-Zip.iso\shell'
    $handler  = '{9ab3b1c9-3225-4bb4-93b6-bfb3c0d93743}'
    Set-RegValue $shellSub '' 'mount'
    Set-RegValue "$shellSub\mount" 'MUIVerb' 'Mount'
    Set-RegValue "$shellSub\mount" 'ExplorerCommandHandler' $handler
    Set-RegValue "$shellSub\mount\command" '' 'C:\WINDOWS\Explorer.exe'
    Set-RegValue "$shellSub\mount\command" 'DelegateExecute' $handler
}

if (-not $NoBackup) {
    $backupDir = Join-Path $env:LOCALAPPDATA 'The Sea Life'
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    $backupPath = Join-Path $backupDir 'associations-backup.json'
    ($backup | ConvertTo-Json -Depth 8) | Set-Content -LiteralPath $backupPath -Encoding UTF8
    Write-Host ("Backup written to: " + $backupPath)
}

Write-Host ("Done. Registered " + $done + " formats.")
Write-Host "Note: Windows forbids programmatic changes to the default app. A few extensions may still need manual confirmation in Settings."
