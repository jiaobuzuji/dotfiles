@echo off
echo "Please run script as Administrator. Right click,run as administrator."

:: current path
:: echo "%~dp0"
cd /d "%~dp0"

mklink "%CD%\..\..\..\project\readme.md" "%CD%\readme.md"
mklink "%HOMEDRIVE%%HOMEPATH%\.gitconfig" "%CD%\..\git\.gitconfig"
mklink "%HOMEDRIVE%%HOMEPATH%\.bashrc" "%CD%\..\shell\.bash_aliases"

pause
