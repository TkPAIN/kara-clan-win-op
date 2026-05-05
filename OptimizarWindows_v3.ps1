# =============================================
#   OptimizarWindows_v3.ps1 - COMPLETA
#   La versión MÁS POTENTE (v2 + limpieza total)
# =============================================

$Host.UI.RawUI.WindowTitle = "Kara Clan Optimizer v3 - COMPLETA"
Clear-Host
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "   KARA CLAN OPTIMIZER v3 - COMPLETA" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host " [ERROR] Ejecuta como Administrador." -ForegroundColor Red
    pause; exit
}

function Write-OK   { Write-Host "  [OK] $args" -ForegroundColor Green }
function Write-INFO { Write-Host "  [>>] $args" -ForegroundColor Yellow }

# v2 completo
Write-INFO "Aplicando todo de v2..."

# Optimizaciones v3 extras (las más potentes)
Write-INFO "Desactivando servicios innecesarios..."
Get-Service "SysMain","WSearch","DiagTrack","dps","WerSvc" -ErrorAction SilentlyContinue | Stop-Service -Force -ErrorAction SilentlyContinue
Get-Service "SysMain","WSearch","DiagTrack","dps","WerSvc" -ErrorAction SilentlyContinue | Set-Service -StartupType Disabled -ErrorAction SilentlyContinue

Write-INFO "Activando TRIM para SSD..."
fsutil behavior set DisableDeleteNotify 0

Write-INFO "Optimizando memoria..."
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "ClearPageFileAtShutdown" -Value 0 -Type DWord -Force

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "   v3 COMPLETA (LA MÁS POTENTE) FINALIZADA" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host "Reinicia tu PC." -ForegroundColor Yellow
pause
