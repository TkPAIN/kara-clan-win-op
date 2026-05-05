# OptimizarWindows_v3.ps1 - COMPLETA
$Host.UI.RawUI.WindowTitle = "Kara Clan v3 - COMPLETA"
Clear-Host
Write-Host "KARA CLAN v3 - COMPLETA" -ForegroundColor Cyan

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Ejecuta como Administrador" -ForegroundColor Red
    pause; exit
}

# Todo de v2
Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object {
    Set-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -Value 1 -Force
    Set-ItemProperty -Path $_.PSPath -Name "TCPNoDelay" -Value 1 -Force
}
Get-NetAdapter | Where Status -eq "Up" | ForEach-Object {
    Set-DnsClientServerAddress -InterfaceIndex $_.InterfaceIndex -ServerAddresses "1.1.1.1","1.0.0.1"
}
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "GPU Priority" -Value 8 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Priority" -Value 6 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Scheduling Category" -Value "High" -Type String -Force

# Extras v3 (más potentes)
Get-Service "SysMain","WSearch","DiagTrack","dps","WerSvc" -ErrorAction SilentlyContinue | Stop-Service -Force
Get-Service "SysMain","WSearch","DiagTrack","dps","WerSvc" -ErrorAction SilentlyContinue | Set-Service -StartupType Disabled
fsutil behavior set DisableDeleteNotify 0

Write-Host "✅ v3 COMPLETA (la más potente) finalizada" -ForegroundColor Green
Write-Host "Reinicia tu PC" -ForegroundColor Yellow
pause
