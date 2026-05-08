# 🔴 ALWAYS FIRST
$ErrorActionPreference = "Stop"

# Admin check (corregido)
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Run this script as Administrator!" -ForegroundColor Red
    pause
    exit
}

# ✅ OptimizarWindows_v1.ps1 - BASICA
$Host.UI.RawUI.WindowTitle = "Kara Clan v1 - BASICA"
Clear-Host
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   KARA CLAN - OPTIMIZADOR v1" -ForegroundColor Cyan
Write-Host "   Red y Rendimiento - Windows 10/11" -ForegroundColor DarkCyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[>>] TcpAckFrequency + TCPNoDelay (Nagle OFF)..." -ForegroundColor Yellow
$ifaces = Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
foreach ($i in $ifaces) {
    Set-ItemProperty -Path $i.PSPath -Name "TcpAckFrequency" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $i.PSPath -Name "TCPNoDelay" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
}
Write-Host "  [OK] Nagle OFF en $($ifaces.Count) interfaces" -ForegroundColor Green

Write-Host "[>>] Plan de energia Alto Rendimiento..." -ForegroundColor Yellow
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null
Write-Host "  [OK] Alto Rendimiento activado" -ForegroundColor Green

Write-Host "[>>] DNS Cloudflare 1.1.1.1..." -ForegroundColor Yellow
$adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
foreach ($a in $adapters) {
    Set-DnsClientServerAddress -InterfaceIndex $a.InterfaceIndex -ServerAddresses ("1.1.1.1","1.0.0.1") -ErrorAction SilentlyContinue
}
Write-Host "  [OK] DNS configurado en $($adapters.Count) adaptadores" -ForegroundColor Green

Write-Host "[>>] Flush DNS cache..." -ForegroundColor Yellow
ipconfig /flushdns | Out-Null
Write-Host "  [OK] Cache DNS limpiada" -ForegroundColor Green

Write-Host "[>>] Optimizacion de Distribucion OFF..." -ForegroundColor Yellow
$doPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"
if (-not (Test-Path $doPath)) { New-Item -Path $doPath -Force | Out-Null }
Set-ItemProperty -Path $doPath -Name "DODownloadMode" -Value 0 -Type DWord -Force
Write-Host "  [OK] P2P Updates OFF" -ForegroundColor Green

Write-Host "[>>] Limite ancho de banda 1 Mbps..." -ForegroundColor Yellow
$doPath2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings"
if (-not (Test-Path $doPath2)) { New-Item -Path $doPath2 -Force | Out-Null }
Set-ItemProperty -Path $doPath2 -Name "DownloadRateBackgroundBps" -Value 125000 -Type DWord -Force
Write-Host "  [OK] Limite: 1 Mbps" -ForegroundColor Green

Write-Host "[>>] Telemetria OFF..." -ForegroundColor Yellow
$telPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
if (-not (Test-Path $telPath)) { New-Item -Path $telPath -Force | Out-Null }
Set-ItemProperty -Path $telPath -Name "AllowTelemetry" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
Write-Host "  [OK] Telemetria OFF" -ForegroundColor Green

Write-Host "[>>] Apps en segundo plano OFF..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
Write-Host "  [OK] Apps BG OFF" -ForegroundColor Green

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   KARA CLAN - COMPLETADO - 8 mejoras" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Reinicia el PC para aplicar los cambios." -ForegroundColor Yellow
Write-Host ""
pause
