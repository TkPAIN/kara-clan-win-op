# ============================================================
# Kara Clan Portable v2 - USER LEVEL ONLY
# No requiere Administrador (funciones limitadas)
# Ejecutar en PowerShell (no necesita Admin)
# ============================================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   KARA CLAN PORTABLE v2" -ForegroundColor Cyan
Write-Host "   Optimizaciones a nivel de usuario" -ForegroundColor DarkCyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[INFO] Las optimizaciones que requieren Administrador no se aplican" -ForegroundColor Yellow
Write-Host ""

Write-Host ">>> Aplicando optimizaciones de usuario..." -ForegroundColor Cyan

# 1. Limpiar cache DNS
Write-Host "  Limpiando cache DNS..." -ForegroundColor Gray
ipconfig /flushdns | Out-Null
Write-Host "    [OK] Cache DNS limpiada" -ForegroundColor Green

# 2. Optimizaciones de rendimiento de usuario
Write-Host "  Optimizando configuraciones de usuario..." -ForegroundColor Gray

# Desactivar animaciones
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Force -EA 0
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value "0" -Force -EA 0
Write-Host "    [OK] Animaciones UI reducidas" -ForegroundColor Green

# Game Mode
$gmPath = "HKCU:\SOFTWARE\Microsoft\GameBar"
if (-not (Test-Path $gmPath)) { New-Item -Path $gmPath -Force | Out-Null }
Set-ItemProperty -Path $gmPath -Name "AutoGameModeEnabled" -Value 1 -Type DWord -Force -EA 0
Write-Host "    [OK] Game Mode activado" -ForegroundColor Green

# Apps en segundo plano OFF
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Value 1 -Type DWord -Force -EA 0
Write-Host "    [OK] Apps en segundo plano desactivadas" -ForegroundColor Green

# GPU Priority
$gpuPath = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
if (-not (Test-Path $gpuPath)) { New-Item -Path $gpuPath -Force | Out-Null }
Set-ItemProperty -Path $gpuPath -Name "GPU Priority" -Value 8 -Type DWord -Force -EA 0
Set-ItemProperty -Path $gpuPath -Name "Priority" -Value 6 -Type DWord -Force -EA 0
Write-Host "    [OK] GPU Priority configurada" -ForegroundColor Green

# Xbox Game Bar (usuario)
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0 -Type DWord -Force -EA 0
Write-Host "    [OK] Xbox Game Bar desactivada" -ForegroundColor Green

# Mejoras de red a nivel de usuario
Write-Host "  Optimizando red (nivel usuario)..." -ForegroundColor Gray
netsh int tcp set global autotuninglevel=normal > $null 2>&1
Write-Host "    [OK] TCP AutoTuning configurado" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   PORTABLE v2 - COMPLETADO" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[NOTA] Para optimizaciones completas (Nagle, DNS, servicios, QoS)," -ForegroundColor Yellow
Write-Host "       ejecuta la versión normal como Administrador." -ForegroundColor Yellow
Write-Host ""
Write-Host "Presiona cualquier tecla para salir..."
pause
