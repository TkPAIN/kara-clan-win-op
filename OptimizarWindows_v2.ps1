# ================================================================
#   OptimizarWindows_v2.ps1
#   Optimizacion AVANZADA para Gaming + GPU (Windows 10/11)
#   Más optimizado que v1 - Ejecutar como Administrador
# ================================================================

$ErrorActionPreference = 'Continue'
$Host.UI.RawUI.WindowTitle = "Optimizador Windows v2 - ADVANCED"
$Host.UI.RawUI.BackgroundColor = "Black"
Clear-Host

function Write-OK   { Write-Host "  [OK] $args" -ForegroundColor Green }
function Write-INFO { Write-Host "  [>>] $args" -ForegroundColor Cyan }
function Write-ERR  { Write-Host "  [ERROR] $args" -ForegroundColor Red }

Write-Host ""
Write-Host "  ╔════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║   OPTIMIZADOR WINDOWS v2 - GAMING ADVANCED ║" -ForegroundColor Cyan
Write-Host "  ╚════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Admin check
$esAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-NOT $esAdmin) {
    Write-ERR "Debes ejecutar como Administrador."
    pause; exit
}

Write-INFO "Iniciando optimización AVANZADA..."

# ─── v1 features (kept + improved) ───
Write-INFO "Aplicando Nagle's Algorithm OFF..."
$ifacesPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
Get-ChildItem $ifacesPath | ForEach-Object {
    Set-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $_.PSPath -Name "TCPNoDelay" -Value 1 -Type DWord -Force
}
Write-OK "Nagle OFF aplicado"

# High Performance + more
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
Write-OK "Plan Alto Rendimiento activado"

# DNS Cloudflare
Get-NetAdapter | Where Status -eq "Up" | ForEach-Object {
    Set-DnsClientServerAddress -InterfaceIndex $_.InterfaceIndex -ServerAddresses "1.1.1.1","1.0.0.1"
}
Write-OK "DNS Cloudflare configurado"

# ─── NEW v2 GAMING TWEAKS ───
Write-INFO "Aplicando optimizaciones Gaming + GPU..."

# Game Mode + GPU Priority
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "GPU Priority" -Value 8 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Priority" -Value 6 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Scheduling Category" -Value "High" -Type String -Force
Write-OK "GPU Priority + Game Mode optimizado"

# DSCP + Network QoS
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "DisableTaskOffload" -Value 0 -Type DWord -Force
Write-OK "QoS / DSCP habilitado"

# More network tweaks
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global rss=enabled
netsh int tcp set global ecncapability=enabled
Write-OK "TCP/IP avanzado configurado"

# Disable power throttling
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" -Name "Attributes" -Value 2 -Type DWord -Force
Write-OK "Power Throttling desactivado"

Write-Host ""
Write-Host "  ╔════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "  ║   OPTIMIZACIÓN v2 - GAMING COMPLETADA     ║" -ForegroundColor Green
Write-Host "  ╚════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-OK "Reinicia tu PC para aplicar todos los cambios"
pause
