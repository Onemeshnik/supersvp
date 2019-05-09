@echo off
cls
setlocal
:Check administrative privileges
fsutil dirty query %systemdrive% > nul
if errorlevel 1 goto :noAdmin
xcopy /Y /H "%~dp0\Distr\AviSynth32\AviSynth.dll" "%WINDIR%\System32"
xcopy /Y /H "%~dp0\Distr\AviSynth64\AviSynth.dll" "%WINDIR%\SysWow64"
regedit /S "Import avs to context menu.reg"
echo Uctanovka zaverwena
goto :end
:noAdmin
echo  This batch file must run with elevated privileges, so:
echo.
echo  Right click on it and chose "Run as administrator"
:end
pause