@echo off
chcp 65001 >nul
echo Restoring original file associations...
"%WINDIR%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Remove-Associations.ps1" -Root "%~dp0"
echo.
pause
