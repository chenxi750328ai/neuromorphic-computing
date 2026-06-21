@echo off
chcp 65001 >nul
echo ========================================
echo  Atlas 200I DK A2 — USB RNDIS6 修复
echo  右键本文件 -^> 以管理员身份运行
echo ========================================
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0fix-rndis-exclamation.ps1"
echo.
echo 日志: %TEMP%\atlas-rndis-fix.log
pause
