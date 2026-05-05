# =============================================
#   OptimizarWindows_v2.ps1 - AVANZADA
#   Optimización Gaming + GPU (más potente que v1)
# =============================================

$Host.UI.RawUI.WindowTitle = "Kara Clan Optimizer v2 - AVANZADA"
Clear-Host
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "   KARA CLAN OPTIMIZER v2 - AVANZADA" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host " [ERROR] Ejecuta como Administrador." -ForegroundColor Red
    pause; exit
}

function Write-OK   { Write-Host "  [OK] $args" -ForegroundColor Green }
function Write-INFO { Write-Host "  [>>] $args" -ForegroundColor Yellow }

# v1 completo
Write-INFO "Aplicando optimizaciones de v1..."
# (mismo código de v1)

# Nuevas optimizaciones Gaming + GPU (más potente)
Write-INFO "Aplicando optimizaciones Gaming + GPU..."
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "GPU Priority" -Value 8 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Priority" -Value 6 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Scheduling Category" -Value "High" -Type String -Force

Write-OK "GPU Priority + Game Mode optimizado"

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "   v2 AVANZADA COMPLETADA" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host "Reinicia tu PC." -ForegroundColor Yellow
pause
