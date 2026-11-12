@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0gen_voz.ps1"
echo.
if exist "%~dp0resultado.txt" type "%~dp0resultado.txt"
echo.
pause
