<#
.SYNOPSIS
    The Sea Life - Restore the original file associations and icons (HKCU only).
#>
[CmdletBinding()]
param([string]$Root = $PSScriptRoot)

$ErrorActionPreference = 'Stop'
$HKCU = [Microsoft.Win32.Registry]::CurrentUser
$backupPath = Join-Path $env:LOCALAPPDATA 'The Sea Life\associations-backup.json'

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
    if ($null -ne $k) { try { $k.DeleteValue($Name, $false) } catch { } finally { $k.Close() } }
}
function Remove-SubKeyTree {
    param([string]$SubKey)
    try { $HKCU.DeleteSubKeyTree($SubKey, $false) } catch { }
}

if (Test-Path -LiteralPath $backupPath) {
    $b = Get-Content -LiteralPath $backupPath -Raw -Encoding UTF8 | ConvertFrom-Json
    foreach ($p in $b.ext.PSObject.Properties) {
        $ext = $p.Name
        $item = $p.Value
        Remove-SubKeyTree ("Software\Classes\7-Zip." + $ext)
        $extSub = "Software\Classes\." + $ext
        if ($null -ne $item.extDefault) {
            Set-RegValue $extSub '' ([string]$item.extDefault)
        } else {
            Remove-RegValue $extSub ''
        }
        foreach ($entry in $item.shellTypes) {
            $parts = ([string]$entry).Split('|')
            if ($parts.Count -eq 2) { Set-RegValue $parts[0] $parts[1] '' }
        }
    }
    Remove-Item -LiteralPath $backupPath -Force
    Write-Host "Original associations restored from backup."
} else {
    Write-Warning "No backup file found. Doing a generic cleanup."
    foreach ($ext in @('7z','zip','rar','tar','gz','bz2','xz','cab','iso','tgz','tbz2','txz')) {
        Remove-SubKeyTree ("Software\Classes\7-Zip." + $ext)
    }
}
Write-Host "Done. Restart File Explorer or sign out to refresh icons."
