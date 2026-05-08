# 🔴 ALWAYS FIRST
$ErrorActionPreference = "Stop"

# Comprobación correcta de administrador (sin saltos ni espacios mal)
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Run this script as Administrator!" -ForegroundColor Red
    exit
}

# ✅ Tu script empieza aquí
# OptimizarWindows_v2.ps1 - AVANZADA (Gaming + GPU)
$Host.UI.RawUI.WindowTitle = "Kara Clan v2 - AVANZADA"
Clear-Host
Write-Host "KARA CLAN v2 - AVANZADA" -ForegroundColor Cyan

# v1 + extras
Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object {
    Set-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -Value 1 -Force
    Set-ItemProperty -Path $_.PSPath -Name "TCPNoDelay" -Value 1 -Force
}
Get-NetAdapter | Where-Object Status -eq "Up" | ForEach-Object {
    Set-DnsClientServerAddress -InterfaceIndex $_.InterfaceIndex -ServerAddresses "1.1.1.1","1.0.0.1"
}

# Gaming GPU
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "GPU Priority" -Value 8 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Priority" -Value 6 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Scheduling Category" -Value "High" -Type String -Force

Write-Host "✅ v2 AVANZADA completada" -ForegroundColor Green
Write-Host "Reinicia tu PC" -ForegroundColor Yellow
pause
