@echo off
title Kara Clan - Optimizer Vol.2 (ADVANCED / AVANZADO)
echo ============================================
echo KARA CLAN OPTIMIZER - VOL.2 (ES/EN)
echo Advanced Gaming + System
echo ============================================
echo Downloading and running as Administrator...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command \"& { irm https://raw.githubusercontent.com/TkPAIN/kara-clan-win-op/main/OptimizarWindows_v2.ps1 | iex }\"'"
pause
