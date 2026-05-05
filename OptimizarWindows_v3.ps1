# OptimizarWindows_v3.ps1 - COMPLETE
$Host.UI.RawUI.WindowTitle = "Kara Clan Optimizer v3 - COMPLETE"
Clear-Host
Write-Host "KARA CLAN OPTIMIZER v3 - COMPLETE" -ForegroundColor Cyan

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Ejecuta como Administrador!" -ForegroundColor Red
    pause; exit
}

Write-Host "Aplicando optimización completa..." -ForegroundColor Yellow

# v2 + extra
Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object {
    Set-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -Value 1 -Force
    Set-ItemProperty -Path $_.PSPath -Name "TCPNoDelay" -Value 1 -Force
}

# Servicios innecesarios
Get-Service "SysMain","WSearch","DiagTrack","dps","WerSvc" -ErrorAction SilentlyContinue | Stop-Service -Force -ErrorAction SilentlyContinue
Get-Service "SysMain","WSearch","DiagTrack","dps","WerSvc" -ErrorAction SilentlyContinue | Set-Service -StartupType Disabled -ErrorAction SilentlyContinue

# TRIM SSD
fsutil behavior set DisableDeleteNotify 0

Write-Host "v3 COMPLETE finalizado!" -ForegroundColor Green
Write-Host "Reinicia tu PC." -ForegroundColor Yellow
pause
