@echo off
title Kara Clan - Optimizer Vol.1 (BASIC / ESENCIAL)
echo ====================================================
echo KARA CLAN OPTIMIZER - VOL.1 (ES/EN)
echo Basic Network Optimization
echo ====================================================
echo Downloading and running as Administrator...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command \"& { irm https://raw.githubusercontent.com/TkPAIN/kara-clan-win-op/main/OptimizarWindows_v1.ps1 | iex }\"'"
pause
