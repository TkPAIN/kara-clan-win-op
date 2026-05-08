@echo off
title Kara Clan - Optimizer Vol.1 (BASIC / ESENCIAL)
echo ====================================================
echo KARA CLAN OPTIMIZER - VOL.1 (ES/EN)
echo Basic Network Optimization
echo ====================================================
echo Solicitar permisos de administrador...
REM Use a VBScript to re-launch the batch file as admin without corrupting the PowerShell command
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B
:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
echo.
echo Downloading and running as Administrator...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command Invoke-Expression (Invoke-RestMethod https://raw.githubusercontent.com/TkPAIN/kara-clan-win-op/main/OptimizarWindows_v1.ps1)'"
pause
