@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

rem 1. Create an automatic backup on the first run
if not exist "Tower Wizard_BACKUP.pck" (
    echo [WARNING] Creating backup of the original game: Tower Wizard_BACKUP.pck ...
    copy "Tower Wizard.pck" "Tower Wizard_BACKUP.pck" >nul
    echo Backup created successfully!
    echo.
)

:menu
cls
echo ===========================================
echo     LANGUAGE MANAGER - TOWER WIZARD
echo ===========================================
echo Choose the language to apply to the game:
echo.
echo 1. Japanese (translation_jp.csv)
echo 2. Portuguese (translation_ptbr.csv)
echo 3. Spanish (translation_esp.csv)
echo 4. English / Original (translation.csv)
echo 5. Restore Original Backup
echo 6. Exit
echo ===========================================
set /p choice="Enter the option number: "

if "%choice%"=="1" set "csv_file=translation_jp.csv"
if "%choice%"=="2" set "csv_file=translation_ptbr.csv"
if "%choice%"=="3" set "csv_file=translation_esp.csv"
if "%choice%"=="4" set "csv_file=translation.csv"
if "%choice%"=="5" goto restore_backup
if "%choice%"=="6" exit

rem Check for invalid input
if "%choice%" lss "1" goto menu
if "%choice%" gtr "6" goto menu

rem Check if the selected CSV file actually exists in the folder
if not exist "%csv_file%" (
    echo.
    echo [ERROR] The file "%csv_file%" was not found in this folder!
    pause
    goto menu
)

echo.
echo Injecting the file "%csv_file%" into the game...
gdtr-tools.exe "--replace-translation=Tower Wizard.pck" "--output=Tower Wizard.pck" --translation-csv="%csv_file%"=res://translation.csv

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Failed to inject translation. gdtr-tools encountered a problem.
    pause
    goto menu
)

echo.
echo ===========================================
echo TRANSLATION APPLIED SUCCESSFULLY!
echo ===========================================
pause
goto menu

:restore_backup
echo.
if not exist "Tower Wizard_BACKUP.pck" (
    echo [ERROR] No backup found to restore.
    pause
    goto menu
)
echo Restoring the game to its original version...
copy /y "Tower Wizard_BACKUP.pck" "Tower Wizard.pck" >nul
echo.
echo Game restored successfully!
pause
goto menu