<#
.SYNOPSIS
    Assemble the portable zip from an existing Dark7zip folder.
#>
[CmdletBinding()]
param(
    [string]$Source = 'D:/app/Dark7-Zip',
    [string]$Name   = 'The-Sea-Life'
)

$ErrorActionPreference = 'Stop'
$repo   = Split-Path $PSScriptRoot -Parent
$stage  = Join-Path $PSScriptRoot 'staging'
$outDir = Join-Path $repo 'releases'

if (-not (Test-Path -LiteralPath $Source)) { throw "Source folder not found: $Source" }
if (-not (Test-Path -LiteralPath (Join-Path $Source '7z.exe'))) { throw "7z.exe not found in $Source" }

Remove-Item -LiteralPath $stage -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $stage -Force | Out-Null
New-Item -ItemType Directory -Path $outDir -Force | Out-Null

# program files (skip the stock uninstaller - this is a portable build)
Get-ChildItem -LiteralPath $Source -File |
    Where-Object { $_.Name -ne 'Uninstall.exe' } |
    Copy-Item -Destination $stage -Force

foreach ($sub in @('Lang', 'Icons')) {
    Copy-Item -LiteralPath (Join-Path $Source $sub) -Destination $stage -Recurse -Force
}
foreach ($item in @('scripts', 'licenses', '一键关联.bat', '取消关联.bat', 'LICENSES.md', 'README.md')) {
    Copy-Item -LiteralPath (Join-Path $repo $item) -Destination $stage -Recurse -Force
}

$zip = Join-Path $outDir ($Name + '-26.06-x64-Portable.zip')
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
& (Join-Path $Source '7z.exe') a -tzip -mx=9 $zip (Join-Path $stage '*') -r | Out-Null
if ($LASTEXITCODE -ne 0) { throw "7z packing failed with code $LASTEXITCODE" }
Write-Host ("Built: " + $zip)
