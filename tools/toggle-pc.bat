@echo off
rem Turns a Phantasy Star Nova patch on or off in Vita3K on PC (takes effect the next time the game is launched).
rem Put this file next to Vita3K.exe (it works on the "patch" folder beside it).
rem   toggle-pc.bat 60fps | camera | bloom20 | bloom50 | bloom0
setlocal
set "P=%~dp0patch"
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
if exist "%P%\%F%.txt" (
  ren "%P%\%F%.txt" "%F%.txt.off"
  echo %F% is now OFF.
) else if exist "%P%\%F%.txt.off" (
  ren "%P%\%F%.txt.off" "%F%.txt"
  echo %F% is now ON.
) else (
  echo Could not find %F%.txt in "%P%".
)
echo Restart the game for it to take effect.
pause
