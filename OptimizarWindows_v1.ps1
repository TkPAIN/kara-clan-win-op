# OptimizarWindows_v1.ps1 - BASIC
$Host.UI.RawUI.WindowTitle = "Kara Clan Optimizer v1 - BASIC"
Clear-Host
Write-Host "KARA CLAN OPTIMIZER v1 - BASIC" -ForegroundColor Cyan

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Run as Administrator!" -ForegroundColor Red
    pause; exit
}

# Nagle OFF + TCP tweaks
Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object {
    Set-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -Value 1 -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $_.PSPath -Name "TCPNoDelay" -Value 1 -Force -ErrorAction SilentlyContinue
}

# Cloudflare DNS
Get-NetAdapter | Where Status -eq "Up" | ForEach-Object {
    Set-DnsClientServerAddress -InterfaceIndex $_.InterfaceIndex -ServerAddresses "1.1.1.1","1.0.0.1" -ErrorAction SilentlyContinue
}

Write-Host "v1 BASIC completed! Restart PC." -ForegroundColor Green
pause
