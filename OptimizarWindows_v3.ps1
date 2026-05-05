# ================================================================
#   OptimizarWindows_v3.ps1
#   Optimizacion COMPLETA - Servicios, Registro, Disco y Memoria
#   Ejecutar como Administrador
# ================================================================
# INSTRUCCIONES:
# 1. Clic derecho sobre este archivo
# 2. "Ejecutar con PowerShell"
# 3. Si aparece error de permisos, abre PowerShell como admin y:
#    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
#    Luego arrastra este archivo a la ventana y pulsa Enter
# ================================================================

$ErrorActionPreference = 'SilentlyContinue'
$Host.UI.RawUI.WindowTitle = "Optimizador Windows v3"
$Host.UI.RawUI.BackgroundColor = "Black"
Clear-Host

function Write-Step  { param([string]$n,[string]$t); Write-Host "  " -NoNewline; Write-Host " $n " -BackgroundColor Yellow -ForegroundColor Black -NoNewline; Write-Host "  $t" -ForegroundColor White }
function Write-OK    { Write-Host "       OK  $args" -ForegroundColor Green }
function Write-SKIP  { Write-Host "     SKIP  $args" -ForegroundColor DarkGray }
function Write-WARN  { Write-Host "     WARN  $args" -ForegroundColor Yellow }
function Write-ERR   { Write-Host "      ERR  $args" -ForegroundColor Red }

function Disable-Svc {
    param([string]$name,[string]$label)
    try {
        $svc = Get-Service -Name $name -ErrorAction Stop
        if ($svc.StartType -ne 'Disabled') {
            Stop-Service -Name $name -Force -EA SilentlyContinue
            Set-Service -Name $name -StartupType Disabled -EA SilentlyContinue
            Write-OK "Desactivado: $label"
        } else { Write-SKIP "Ya desactivado: $label" }
    } catch { Write-SKIP "No encontrado: $label" }
}

# Verificar administrador
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host ""
    Write-ERR "Ejecuta como Administrador."
    Write-Host "  Clic derecho > 'Ejecutar con PowerShell'" -ForegroundColor Yellow
    pause; exit
}

Write-Host ""
Write-Host "  ╔══════════════════════════════════════════╗" -ForegroundColor Yellow
Write-Host "  ║  OPTIMIZADOR WINDOWS v3 - COMPLETO      ║" -ForegroundColor Yellow
Write-Host "  ╚══════════════════════════════════════════╝" -ForegroundColor Yellow
Write-Host "  Servicios | Registro | Disco | Memoria" -ForegroundColor DarkYellow
Write-Host ""
Start-Sleep -Milliseconds 500

# ════════════════════════════════════════
# SERVICIOS
# ════════════════════════════════════════
Write-Host "  [ SERVICIOS ]" -ForegroundColor Yellow
Write-Host "  ----------------------------------------" -ForegroundColor DarkGray
Disable-Svc "DiagTrack"          "Telemetria"
Disable-Svc "dmwappushservice"   "WAP Push"
Disable-Svc "WerSvc"             "Informe errores"
Disable-Svc "Spooler"            "Cola impresion"
Disable-Svc "Fax"                "Fax"
Disable-Svc "XblAuthManager"     "Xbox Live Auth"
Disable-Svc "XblGameSave"        "Xbox Game Save"
Disable-Svc "XboxNetApiSvc"      "Xbox Networking"
Disable-Svc "MapsBroker"         "Mapas"
Disable-Svc "lfsvc"              "Geolocalizacion"
Disable-Svc "RemoteRegistry"     "Registro remoto"
Disable-Svc "RetailDemo"         "Modo demo"
Disable-Svc "WMPNetworkSvc"      "WMP red"

Write-Host ""

# ════════════════════════════════════════
# REGISTRO
# ════════════════════════════════════════
Write-Host "  [ REGISTRO ]" -ForegroundColor Cyan
Write-Host "  ----------------------------------------" -ForegroundColor DarkGray

Write-Step "02" "Animaciones OFF"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00))
$vfxPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
if (-not (Test-Path $vfxPath)) { New-Item -Path $vfxPath -Force | Out-Null }
Set-ItemProperty -Path $vfxPath -Name "VisualFXSetting" -Value 2 -Type DWord -Force
Write-OK "Animaciones minimas"

Write-Step "03" "CPU Priority maximo"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38 -Type DWord -Force
Write-OK "Prioridad CPU = 38"

Write-Step "04" "Cortana OFF"
$cPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
if (-not (Test-Path $cPath)) { New-Item -Path $cPath -Force | Out-Null }
Set-ItemProperty -Path $cPath -Name "AllowCortana" -Value 0 -Type DWord -Force
Write-OK "Cortana desactivada"

Write-Step "05" "Reinicio apps OFF"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "RestartApps" -Value 0 -Type DWord -Force
Write-OK "Reinicio apps desactivado"

Write-Step "06" "Apagado rapido"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WaitToKillAppTimeout" -Value "2000" -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "WaitToKillServiceTimeout" -Value "2000" -Force
Write-OK "Timeout apagado reducido"

Write-Step "07" "Tips OFF"
$tPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
if (-not (Test-Path $tPath)) { New-Item -Path $tPath -Force | Out-Null }
Set-ItemProperty -Path $tPath -Name "SoftLandingEnabled" -Value 0 -Type DWord -Force
Write-OK "Tips y sugerencias desactivados"

Write-Host ""

# ════════════════════════════════════════
# DISCO
# ════════════════════════════════════════
Write-Host "  [ DISCO ]" -ForegroundColor Green
Write-Host "  ----------------------------------------" -ForegroundColor DarkGray

Write-Step "08" "Limpiando temporales"
$total = 0
foreach ($f in @($env:TEMP,"C:\Windows\Temp","C:\Windows\Prefetch")) {
    if (Test-Path $f) {
        $sz = (Get-ChildItem $f -Recurse -Force -EA SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        Remove-Item "$f\*" -Recurse -Force -EA SilentlyContinue
        if ($sz) { $total += $sz }
    }
}
Write-OK "Liberados ~$([math]::Round($total/1MB,1)) MB"

Write-Step "09" "Cache Update limpia"
Stop-Service "wuauserv" -Force -EA SilentlyContinue
Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -EA SilentlyContinue
Start-Service "wuauserv" -EA SilentlyContinue
Write-OK "Cache limpiada"

Write-Step "10" "TRIM SSD"
try { Optimize-Volume -DriveLetter C -ReTrim -Verbose:$false -EA Stop; Write-OK "TRIM ejecutado" } catch { Write-SKIP "No disponible" }

Write-Step "11" "Indexacion OFF"
$drv = Get-CimInstance -Class Win32_Volume -Filter "DriveLetter='C:'" -EA SilentlyContinue
if ($drv) { $drv | Set-CimInstance -Property @{IndexingEnabled=$false} -EA SilentlyContinue; Write-OK "Indexacion desactivada" }

Write-Step "12" "NTFS 8.3 + LastAccess OFF"
fsutil behavior set disable8dot3 1 | Out-Null
fsutil behavior set disablelastaccess 1 | Out-Null
Write-OK "Optimizaciones NTFS aplicadas"

Write-Host ""

# ════════════════════════════════════════
# MEMORIA
# ════════════════════════════════════════
Write-Host "  [ MEMORIA ]" -ForegroundColor Magenta
Write-Host "  ----------------------------------------" -ForegroundColor DarkGray

$memPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"

Write-Step "13" "ClearPageFile OFF"
Set-ItemProperty -Path $memPath -Name "ClearPageFileAtShutdown" -Value 0 -Type DWord -Force
Write-OK "Apagado mas rapido"

Write-Step "14" "LargeSystemCache OFF"
Set-ItemProperty -Path $memPath -Name "LargeSystemCache" -Value 0 -Type DWord -Force
Write-OK "Prioridad a apps"

Write-Step "15" "AlwaysUnloadDLL ON"
$expPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
if (-not (Test-Path $expPath)) { New-Item -Path $expPath -Force | Out-Null }
Set-ItemProperty -Path $expPath -Name "AlwaysUnloadDLL" -Value 1 -Type DWord -Force
Write-OK "DLLs liberadas al minimizar"

Write-Host ""
Write-Host "  ╔══════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "  ║   OPTIMIZACION v3 COMPLETADA            ║" -ForegroundColor Green
Write-Host "  ╚══════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-WARN "Reinicia el PC para aplicar todos los cambios."
Write-Host ""
pause
