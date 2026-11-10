@echo off
rem Turns a Phantasy Star Nova patch on or off in Vita3K Plus on an Android device over adb
rem (USB debugging on, device connected and awake). Takes effect the next time the game is launched.
rem   toggle-android.bat 60fps | camera | bloom20 | bloom50 | bloom0
rem Set ADB below to your adb.exe, and PKG if your Vita3K build uses another package name.
setlocal
set "ADB=adb"
set "PKG=org.vita3kplus.emulator"
set "D=/sdcard/Android/data/%PKG%/files/patch"
set "WHAT=%~1"
if /I "%WHAT%"=="60fps" set "F=PCSG00351_60FPS"
if /I "%WHAT%"=="camera" set "F=PCSG00351_CAMERA"
if /I "%WHAT%"=="bloom20" set "F=PCSG00351_BLOOM20"
if /I "%WHAT%"=="bloom50" set "F=PCSG00351_BLOOM50"
if /I "%WHAT%"=="bloom0" set "F=PCSG00351_BLOOM0"
if not defined F (
  echo Usage: %~nx0 60fps ^| camera ^| bloom20 ^| bloom50 ^| bloom0
  exit /b 1
)
set MSYS_NO_PATHCONV=1
"%ADB%" shell "if [ -f %D%/%F%.txt ]; then mv %D%/%F%.txt %D%/%F%.txt.off && echo %F% is now OFF; elif [ -f %D%/%F%.txt.off ]; then mv %D%/%F%.txt.off %D%/%F%.txt && echo %F% is now ON; else echo %F% not found in %D%; fi"
echo Restart the game for it to take effect.
