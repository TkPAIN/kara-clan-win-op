# ================================================================
#   OptimizarWindows_v1.ps1
#   Optimizacion de red basica para Windows 10/11
#   Ejecutar como Administrador
# ================================================================
# INSTRUCCIONES:
# 1. Clic derecho sobre este archivo
# 2. "Ejecutar con PowerShell"
# 3. Si aparece error de permisos, copia y pega esto en PowerShell Admin:
#    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
#    Luego arrastra este archivo a la ventana y pulsa Enter
# ================================================================

$ErrorActionPreference = 'Continue'
$Host.UI.RawUI.WindowTitle = "Optimizador Windows v1"
$Host.UI.RawUI.BackgroundColor = "Black"
Clear-Host

function Write-OK   { Write-Host "  [OK] $args" -ForegroundColor Green }
function Write-INFO { Write-Host "  [>>] $args" -ForegroundColor Yellow }
function Write-ERR  { Write-Host "  [ERROR] $args" -ForegroundColor Red }

# Banner
Write-Host ""
Write-Host "  ╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║   OPTIMIZADOR WINDOWS v1 - RED BASICA   ║" -ForegroundColor Cyan
Write-Host "  ╚══════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Verificar administrador
$esAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-NOT $esAdmin) {
    Write-ERR "Debes ejecutar como Administrador."
    Write-Host "  Clic derecho > 'Ejecutar con PowerShell' (como admin)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Presiona cualquier tecla para salir..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

Write-INFO "Iniciando optimizacion de red..."
Write-Host ""
Start-Sleep -Seconds 1

# ─── 1. Nagle's Algorithm OFF ───
Write-INFO "Aplicando TcpAckFrequency y TCPNoDelay..."
try {
    $ifacesPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
    if (Test-Path $ifacesPath) {
        $ifaces = Get-ChildItem -Path $ifacesPath -ErrorAction Stop
        foreach ($i in $ifaces) {
            Set-ItemProperty -Path $i.PSPath -Name "TcpAckFrequency" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $i.PSPath -Name "TCPNoDelay"      -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
        }
        Write-OK "Aplicado en $($ifaces.Count) interfaces"
    } else {
        Write-ERR "No se encontro la ruta del registro"
    }
} catch {
    Write-ERR "Error al modificar el registro: $_"
}

# ─── 2. Plan Alto Rendimiento ───
Write-INFO "Activando plan de energia Alto Rendimiento..."
try {
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null
    if ($LASTEXITCODE -ne 0) {
        powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null
        powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null
    }
    Write-OK "Plan Alto Rendimiento activado"
} catch {
    Write-ERR "No se pudo cambiar el plan de energia"
}

# ─── 3. DNS Cloudflare ───
Write-INFO "Configurando DNS Cloudflare (1.1.1.1 / 1.0.0.1)..."
try {
    $adapters = Get-NetAdapter -ErrorAction Stop | Where-Object { $_.Status -eq "Up" }
    if ($adapters) {
        foreach ($a in $adapters) {
            Set-DnsClientServerAddress -InterfaceIndex $a.InterfaceIndex -ServerAddresses ("1.1.1.1","1.0.0.1") -ErrorAction SilentlyContinue
        }
        Write-OK "DNS configurado en $($adapters.Count) adaptadores"
    } else {
        Write-ERR "No se encontraron adaptadores de red activos"
    }
} catch {
    Write-ERR "Error al configurar DNS: $_"
}

# ─── 4. Flush DNS ───
Write-INFO "Limpiando cache DNS..."
try {
    ipconfig /flushdns | Out-Null
    Write-OK "Cache DNS limpiada"
} catch {
    Write-ERR "Error al limpiar cache DNS"
}

# ─── 5. Delivery Optimization OFF ───
Write-INFO "Desactivando Optimizacion de Distribucion (P2P Updates)..."
try {
    $doPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"
    if (-not (Test-Path $doPath)) { New-Item -Path $doPath -Force | Out-Null }
    Set-ItemProperty -Path $doPath -Name "DODownloadMode" -Value 0 -Type DWord -Force
    Write-OK "Optimizacion de distribucion desactivada"
} catch {
    Write-ERR "Error al modificar Delivery Optimization"
}

# ─── 6. Limite ancho de banda ───
Write-INFO "Limitando ancho de banda de actualizaciones en segundo plano..."
try {
    $doPath2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings"
    if (-not (Test-Path $doPath2)) { New-Item -Path $doPath2 -Force | Out-Null }
    Set-ItemProperty -Path $doPath2 -Name "DownloadRateBackgroundBps" -Value 125000 -Type DWord -Force
    Write-OK "Limite establecido: ~1 Mbps en segundo plano"
} catch {
    Write-ERR "Error al limitar ancho de banda"
}

# ─── 7. Telemetria minima ───
Write-INFO "Reduciendo telemetria al minimo..."
try {
    $telPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    if (-not (Test-Path $telPath)) { New-Item -Path $telPath -Force | Out-Null }
    Set-ItemProperty -Path $telPath -Name "AllowTelemetry" -Value 0 -Type DWord -Force
    Write-OK "Telemetria reducida"
} catch {
    Write-ERR "Error al reducir telemetria"
}

# ─── 8. Apps en segundo plano OFF ───
Write-INFO "Desactivando apps en segundo plano..."
try {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
    Write-OK "Apps en segundo plano desactivadas"
} catch {
    Write-ERR "Error al desactivar apps en segundo plano"
}

# ─── RESUMEN ───
Write-Host ""
Write-Host "  ╔══════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "  ║   OPTIMIZACION v1 COMPLETADA            ║" -ForegroundColor Green
Write-Host "  ╚══════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-OK "Nagle's Algorithm OFF"
Write-OK "Plan Alto Rendimiento ON"
Write-OK "DNS Cloudflare 1.1.1.1"
Write-OK "Cache DNS limpiada"
Write-OK "P2P Updates OFF"
Write-OK "Limite ancho banda BG"
Write-OK "Telemetria minima"
Write-OK "Apps segundo plano OFF"
Write-Host ""
Write-Host "  [AVISO] Reinicia el PC para aplicar todos los cambios." -ForegroundColor Yellow
Write-Host ""
Write-Host "  Presiona cualquier tecla para salir..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
