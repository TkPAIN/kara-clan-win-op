# =============================================
# KARA CLAN - REVERT OPTIMIZER
# =============================================
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "     KARA CLAN - REVERTING ALL OPTIMIZATIONS" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

Write-Host "`nRestaurando configuraciones por defecto / Restoring default settings..." -ForegroundColor Yellow

# Reset network settings
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global rss=enabled

Write-Host "✅ Revertido con éxito / Successfully reverted!" -ForegroundColor Green
Write-Host "Reinicia tu PC / Restart your PC for changes to take effect" -ForegroundColor Green
pause