# OptimizarWindows_v1.ps1 - BÁSICA (Red + DNS)
$Host.UI.RawUI.WindowTitle = "Kara Clan v1 - BÁSICA"
Clear-Host
Write-Host "KARA CLAN v1 - BÁSICA" -ForegroundColor Cyan

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Ejecuta como Administrador" -ForegroundColor Red
    pause; exit
}

# Nagle OFF
Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object {
    Set-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -Value 1 -Force
    Set-ItemProperty -Path $_.PSPath -Name "TCPNoDelay" -Value 1 -Force
}

# DNS Cloudflare
Get-NetAdapter | Where Status -eq "Up" | ForEach-Object {
    Set-DnsClientServerAddress -InterfaceIndex $_.InterfaceIndex -ServerAddresses "1.1.1.1","1.0.0.1"
}

Write-Host "✅ v1 BÁSICA completada" -ForegroundColor Green
Write-Host "Reinicia tu PC" -ForegroundColor Yellow
pause
