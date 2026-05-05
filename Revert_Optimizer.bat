@echo off
title Kara Clan - Revert Optimizer
echo.
echo =============================================
echo   KARA CLAN - REVERT ALL CHANGES (ES/EN)
echo =============================================
echo.
echo Downloading and running as Administrator...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command \"irm https://raw.githubusercontent.com/TkPAIN/kara-clan-win-op/main/Revert_Optimizer.ps1 | iex\"' -Verb RunAs"
