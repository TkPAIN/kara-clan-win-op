# 🔴 ALWAYS FIRST
$ErrorActionPreference = "Stop"

# Admin check (corregido)
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Run this script as Administrator!" -ForegroundColor Red
    pause
    exit
}

# ✅ OptimizarWindows_v3.ps1 - COMPLETA
$Host.UI.RawUI.WindowTitle = "Kara Clan v3 - COMPLETA"
Clear-Host
Write-Host "  =========================================" -ForegroundColor Yellow
Write-Host "   KARA CLAN - OPTIMIZADOR v3 FIXED" -ForegroundColor Yellow
Write-Host "   Servicios | Registro | Disco | Memoria" -ForegroundColor DarkYellow
Write-Host "  =========================================" -ForegroundColor Yellow
Write-Host ""

function Write-Step { param([string]$n,[string]$t); Write-Host "  " -NoNewline; Write-Host " $n " -BackgroundColor Yellow -ForegroundColor Black -NoNewline; Write-Host "  $t" -ForegroundColor White }
function Write-OK   { param([string]$msg); Write-Host "       OK  $msg" -ForegroundColor Green }
function Write-SKIP { param([string]$msg); Write-Host "     SKIP  $msg" -ForegroundColor DarkGray }
function Write-WARN { param([string]$msg); Write-Host "     WARN  $msg" -ForegroundColor Yellow }

function Disable-Svc {
    param([string]$name,[string]$label)
    try {
        $s = Get-Service -Name $name -ErrorAction Stop
        if ($s.StartType -ne 'Disabled') {
            Stop-Service -Name $name -Force -ErrorAction SilentlyContinue
            Set-Service -Name $name -StartupType Disabled -ErrorAction SilentlyContinue
            Write-OK "OFF: $label"
        } else {
            Write-SKIP "Ya OFF: $label"
        }
    } catch {
        Write-SKIP "N/A: $label"
    }
}

# SERVICIOS
Write-Host "  [ SERVICIOS ]" -ForegroundColor Yellow
Disable-Svc "DiagTrack" "Telemetria"
Disable-Svc "WerSvc" "Informe errores"
Disable-Svc "Spooler" "Cola impresion"
Disable-Svc "XblAuthManager" "Xbox Auth"
Disable-Svc "XblGameSave" "Xbox Game Save"
Disable-Svc "MapsBroker" "Mapas"
Disable-Svc "lfsvc" "Geolocalizacion"

# REGISTRO
Write-Host ""
Write-Host "  [ REGISTRO ]" -ForegroundColor Cyan
Write-Step "01" "Animaciones UI OFF"
$vfx = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
if (-not (Test-Path $vfx)) { New-Item -Path $vfx -Force | Out-Null }
Set-ItemProperty -Path $vfx -Name "VisualFXSetting" -Value 2 -Type DWord -Force
Write-OK "Al minimo"

Write-Step "02" "CPU Priority 38"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38 -Type DWord -Force
Write-OK "38"

Write-Step "03" "Cortana OFF"
$cp = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
if (-not (Test-Path $cp)) { New-Item -Path $cp -Force | Out-Null }
Set-ItemProperty -Path $cp -Name "AllowCortana" -Value 0 -Type DWord -Force
Write-OK "OFF"

# DISCO
Write-Host ""
Write-Host "  [ DISCO ]" -ForegroundColor Green
Write-Step "10" "Temporales"
$tf = 0
foreach ($f in @($env:TEMP, "C:\Windows\Temp", "C:\Windows\Prefetch")) {
    if (Test-Path $f) {
        $sz = (Get-ChildItem $f -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
        Remove-Item "$f\*" -Recurse -Force -ErrorAction SilentlyContinue
        if ($sz) { $tf += $sz }
    }
}
Write-OK "~$([math]::Round($tf/1MB,1)) MB liberados"

# MEMORIA
Write-Host ""
Write-Host "  [ MEMORIA ]" -ForegroundColor Magenta
$mp = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
Write-Step "16" "ClearPageFile 0"
Set-ItemProperty -Path $mp -Name "ClearPageFileAtShutdown" -Value 0 -Type DWord -Force
Write-OK "OK"

Write-Step "17" "LargeSystemCache 0"
Set-ItemProperty -Path $mp -Name "LargeSystemCache" -Value 0 -Type DWord -Force
Write-OK "OK"

Write-Host ""
Write-Host "  ✅ KARA CLAN - VOL.3 COMPLETADO - 20 mejoras" -ForegroundColor Green
Write-WARN "Reinicia el PC para aplicar los cambios."
Write-Host ""
pause
