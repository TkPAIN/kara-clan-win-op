# ================================================================
#   OptimizarWindows_v2.ps1
#   Optimizacion avanzada - Red y Sistema para Windows 10/11
#   Ejecutar como Administrador
# ================================================================
# INSTRUCCIONES:
# 1. Clic derecho sobre este archivo
# 2. "Ejecutar con PowerShell"
# 3. Si aparece error de permisos, abre PowerShell como admin y:
#    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
#    Luego arrastra este archivo a la ventana y pulsa Enter
# ================================================================

$ErrorActionPreference = 'Continue'
$Host.UI.RawUI.WindowTitle = "Optimizador Windows v2"
$Host.UI.RawUI.BackgroundColor = "Black"
Clear-Host

function Write-OK   { Write-Host "       OK  $args" -ForegroundColor Green }
function Write-SKIP { Write-Host "     SKIP  $args" -ForegroundColor DarkGray }
function Write-WARN { Write-Host "     WARN  $args" -ForegroundColor Yellow }
function Write-ERR  { Write-Host "      ERR  $args" -ForegroundColor Red }
function Write-Step { param([string]$n,[string]$t); Write-Host "  [$n] $t" -ForegroundColor Cyan }

# Verificar administrador
$esAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-NOT $esAdmin) {
    Write-Host ""
    Write-ERR "Debes ejecutar como Administrador."
    Write-Host "  Clic derecho > 'Ejecutar con PowerShell'" -ForegroundColor Yellow
    Write-Host ""
    pause
    exit
}

Write-Host ""
Write-Host "  ╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║  OPTIMIZADOR WINDOWS v2 - RED Y SISTEMA ║" -ForegroundColor Cyan
Write-Host "  ╚══════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Start-Sleep -Milliseconds 500

# ════════════════════════════════════════
# BLOQUE 1 - RED
# ════════════════════════════════════════
Write-Host "  [ RED ]" -ForegroundColor Cyan
Write-Host "  ----------------------------------------" -ForegroundColor DarkGray

Write-Step "1" "Nagle's Algorithm OFF"
try {
    $path = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
    $ifaces = Get-ChildItem -Path $path -ErrorAction Stop
    foreach ($i in $ifaces) {
        Set-ItemProperty -Path $i.PSPath -Name "TcpAckFrequency" -Value 1 -Type DWord -Force -EA SilentlyContinue
        Set-ItemProperty -Path $i.PSPath -Name "TCPNoDelay"      -Value 1 -Type DWord -Force -EA SilentlyContinue
    }
    Write-OK "Aplicado en $($ifaces.Count) interfaces"
} catch { Write-ERR "Error: $_" }

Write-Step "2" "DNS Cloudflare 1.1.1.1"
try {
    $adapters = Get-NetAdapter -EA Stop | Where-Object Status -eq "Up"
    foreach ($a in $adapters) {
        Set-DnsClientServerAddress -InterfaceIndex $a.InterfaceIndex -ServerAddresses ("1.1.1.1","1.0.0.1") -EA SilentlyContinue
    }
    Write-OK "DNS Cloudflare configurado"
} catch { Write-ERR "Error: $_" }

Write-Step "3" "Flush DNS"
ipconfig /flushdns | Out-Null
Write-OK "Cache DNS limpiada"

Write-Step "4" "P2P Updates OFF"
$doPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"
if (-not (Test-Path $doPath)) { New-Item -Path $doPath -Force | Out-Null }
Set-ItemProperty -Path $doPath -Name "DODownloadMode" -Value 0 -Type DWord -Force
Write-OK "Optimizacion distribucion desactivada"

Write-Step "5" "Limite ancho banda BG (1 Mbps)"
$doPath2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings"
if (-not (Test-Path $doPath2)) { New-Item -Path $doPath2 -Force | Out-Null }
Set-ItemProperty -Path $doPath2 -Name "DownloadRateBackgroundBps" -Value 125000 -Type DWord -Force
Write-OK "Limite 1 Mbps en segundo plano"

Write-Step "6" "QoS DSCP 46 (Gaming)"
$qosPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\QoS\Gaming"
if (-not (Test-Path $qosPath)) { New-Item -Path $qosPath -Force | Out-Null }
Set-ItemProperty -Path $qosPath -Name "DSCP Value" -Value "46" -Force -EA SilentlyContinue
Set-ItemProperty -Path $qosPath -Name "Throttle Rate" -Value "-1" -Force -EA SilentlyContinue
Write-OK "QoS DSCP 46 activado"

Write-Step "7" "Reserva ancho banda 0%"
$qosLimit = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched"
if (-not (Test-Path $qosLimit)) { New-Item -Path $qosLimit -Force | Out-Null }
Set-ItemProperty -Path $qosLimit -Name "NonBestEffortLimit" -Value 0 -Type DWord -Force
Write-OK "Reserva eliminada (de 20% a 0%)"

Write-Step "8" "Network Throttling OFF"
$mmPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
Set-ItemProperty -Path $mmPath -Name "NetworkThrottlingIndex" -Value 0xFFFFFFFF -Type DWord -Force -EA SilentlyContinue
Write-OK "Throttling de red desactivado"

Write-Host ""

# ════════════════════════════════════════
# BLOQUE 2 - SISTEMA
# ════════════════════════════════════════
Write-Host "  [ SISTEMA ]" -ForegroundColor Magenta
Write-Host "  ----------------------------------------" -ForegroundColor DarkGray

Write-Step "9" "Plan Alto Rendimiento"
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null
Write-OK "Activado"

Write-Step "10" "Hibernacion OFF"
powercfg -h off 2>$null
Write-OK "Hibernacion desactivada"

Write-Step "11" "GPU Priority 8"
$gpuPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
if (-not (Test-Path $gpuPath)) { New-Item -Path $gpuPath -Force | Out-Null }
Set-ItemProperty -Path $gpuPath -Name "GPU Priority" -Value 8 -Type DWord -Force -EA SilentlyContinue
Set-ItemProperty -Path $gpuPath -Name "Priority"     -Value 6 -Type DWord -Force -EA SilentlyContinue
Set-ItemProperty -Path $gpuPath -Name "Scheduling Category" -Value "High" -Force -EA SilentlyContinue
Write-OK "GPU 8 | CPU 6"

Write-Step "12" "Telemetria OFF"
$telPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
if (-not (Test-Path $telPath)) { New-Item -Path $telPath -Force | Out-Null }
Set-ItemProperty -Path $telPath -Name "AllowTelemetry" -Value 0 -Type DWord -Force
Write-OK "Telemetria desactivada"

Write-Step "13" "Apps segundo plano OFF"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Value 1 -Type DWord -Force -EA SilentlyContinue
Write-OK "Desactivadas"

Write-Step "14" "Game Bar OFF"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0 -Type DWord -Force -EA SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Value 0 -Type DWord -Force -EA SilentlyContinue
Write-OK "Game Bar y DVR desactivados"

Write-Step "15" "Game Mode ON"
$gmPath = "HKCU:\SOFTWARE\Microsoft\GameBar"
if (-not (Test-Path $gmPath)) { New-Item -Path $gmPath -Force | Out-Null }
Set-ItemProperty -Path $gmPath -Name "AutoGameModeEnabled" -Value 1 -Type DWord -Force -EA SilentlyContinue
Write-OK "Game Mode activado"

Write-Step "16" "SysMain OFF (SSD)"
Stop-Service -Name "SysMain" -Force -EA SilentlyContinue
Set-Service -Name "SysMain" -StartupType Disabled -EA SilentlyContinue
Write-OK "SysMain desactivado (optimo para SSD)"

Write-Step "17" "Windows Search reducido"
Set-Service -Name "WSearch" -StartupType Manual -EA SilentlyContinue
Write-OK "Indexacion en modo manual"

Write-Host ""
Write-Host "  ╔══════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "  ║   OPTIMIZACION v2 COMPLETADA            ║" -ForegroundColor Green
Write-Host "  ╚══════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-OK "17 mejoras aplicadas"
Write-Host ""
Write-WARN "Reinicia el PC para aplicar todos los cambios."
Write-Host ""
pause
