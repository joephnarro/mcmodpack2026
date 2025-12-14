@echo off
setlocal EnableExtensions

title Overwrite Minecraft mods folder

echo.
echo WARNING: This will OVERWRITE your Minecraft mods folder:
echo   "%APPDATA%\.minecraft\mods"
echo.

set /p "CONFIRM=Type yes to continue: "
if /I not "%CONFIRM%"=="yes" goto :abort

set "SRC=%~dp0mods"
set "MC_DIR=%APPDATA%\.minecraft"
set "DEST=%MC_DIR%\mods-test"

if not exist "%SRC%\" (
  set "ERRMSG=Source folder not found: %SRC%"
  goto :fatal
)

if not exist "%MC_DIR%\" (
  set "ERRMSG=Minecraft folder not found: %MC_DIR%"
  goto :fatal
)

echo.
echo Deleting existing mods folder (if present)...
if exist "%DEST%\" (
  rmdir /S /Q "%DEST%"
  if exist "%DEST%\" (
    set "ERRMSG=Failed to delete destination mods folder: %DEST%"
    goto :fatal
  )
) else (
  echo (No existing mods folder found.)
)

echo.
echo Copying new mods folder into .minecraft...
robocopy "%SRC%" "%DEST%" /E /COPY:DAT /DCOPY:DAT /R:0 /W:0 /NFL /NDL /NP >nul
set "RC=%ERRORLEVEL%"

REM Robocopy exit codes: 0-7 are success (with various info), 8+ indicate failure.
if %RC% GEQ 8 (
  set "ERRMSG=Copy failed (robocopy exit code %RC%)."
  goto :fatal
)

if not exist "%DEST%\" (
  set "ERRMSG=Copy finished but destination folder is missing: %DEST%"
  goto :fatal
)

echo.
echo SUCCESS: Mods installed to:
echo   "%DEST%"
echo.
echo You may close this window...
pause>nul
goto :eof

:abort
echo.
echo Aborted. No changes were made.
echo.
echo You may close this window...
pause>nul
goto :eof

:fatal
echo.
echo ERROR: %ERRMSG%
echo.
echo You may close this window...
pause>nul
goto :eof
