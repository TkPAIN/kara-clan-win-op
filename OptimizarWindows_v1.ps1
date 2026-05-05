# =============================================
#   OptimizarWindows_v1.ps1 - BÁSICA
#   Optimización básica de red
#   Ejecutar como Administrador
# =============================================

$Host.UI.RawUI.WindowTitle = "Kara Clan Optimizer v1 - BÁSICA"
Clear-Host
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "   KARA CLAN OPTIMIZER v1 - BÁSICA" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar Administrador
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host " [ERROR] Ejecuta este script como Administrador." -ForegroundColor Red
    pause; exit
}

function Write-OK   { Write-Host "  [OK] $args" -ForegroundColor Green }
function Write-INFO { Write-Host "  [>>] $args" -ForegroundColor Yellow }

Write-INFO "Aplicando TcpAckFrequency y TCPNoDelay..."
$interfaces = Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
foreach ($iface in $interfaces) {
    Set-ItemProperty -Path $iface.PSPath -Name "TcpAckFrequency" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $iface.PSPath -Name "TCPNoDelay"      -Value 1 -Type DWord -Force
}
Write-OK "Nagle's Algorithm desactivado"

Write-INFO "Configurando DNS Cloudflare..."
Get-NetAdapter | Where Status -eq "Up" | ForEach-Object {
    Set-DnsClientServerAddress -InterfaceIndex $_.InterfaceIndex -ServerAddresses "1.1.1.1","1.0.0.1"
}
Write-OK "DNS Cloudflare aplicado"

Write-INFO "Activando plan Alto Rendimiento..."
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "   v1 BÁSICA COMPLETADA" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host "Reinicia tu PC para aplicar los cambios." -ForegroundColor Yellow
pause
