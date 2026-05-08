@echo off
title Kara Clan - Optimizer Vol.3 (COMPLETE / COMPLETO)
echo ====================================================
echo KARA CLAN OPTIMIZER - VOL.3 (ES/EN)
echo Full System + Cleanup
echo ====================================================
echo Downloading and running as Administrator...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command \"& { irm https://raw.githubusercontent.com/TkPAIN/kara-clan-win-op/main/OptimizarWindows_v3.ps1 | iex }\"'"
pause
