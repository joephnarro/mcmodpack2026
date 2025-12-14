@echo off
setlocal EnableExtensions

title Update Pack

git --version >nul 2>&1
if errorlevel 1 goto :install_git

goto :do_pull

:install_git
echo Git was not found on this system.
echo Attempting to install Git using winget...
echo.

winget --version >nul 2>&1
if errorlevel 1 (
  echo ERROR: winget is not available, so Git cannot be installed automatically.
  echo Please install Git manually, then re-run this script.
  goto :end_error
)

winget install --id Git.Git -e
if errorlevel 1 (
  echo.
  echo ERROR: Git install via winget failed.
  goto :end_error
)

echo.
echo Git was installed (or winget reported success).
echo IMPORTANT: Please close this window and re-run the script so Git is on PATH.
goto :end_ok

:do_pull
echo Running git pull in:
echo   "%~dp0"
echo.

pushd "%~dp0" >nul 2>&1
if errorlevel 1 (
  echo ERROR: Failed to switch to the script directory.
  goto :end_error
)

git pull
if errorlevel 1 (
  popd >nul 2>&1
  echo.
  echo ERROR: git pull failed.
  goto :end_error
)

popd >nul 2>&1
echo.
echo SUCCESS: Pack update via git pull completed.
goto :end_ok

:end_error
echo.
echo Script finished with errors.
echo.
echo You may close this window...
pause>nul
goto :eof

:end_ok
echo.
echo You may close this window...
pause>nul
goto :eof
