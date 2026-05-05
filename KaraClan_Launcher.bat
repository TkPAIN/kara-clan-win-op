@echo off
title Kara Clan - All-in-One Launcher
echo.
echo =============================================
echo        KARA CLAN - ALL-IN-ONE LAUNCHER
echo =============================================
echo.
echo Launching beautiful GUI as Administrator...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"%~dp0KaraClan_Launcher.ps1\"' -Verb RunAs"
echo.
echo GUI launched! If UAC appears, click Yes.
pause
