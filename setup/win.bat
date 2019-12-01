@echo off
REM SHIFT-JIS/CRLFで保存すること

REM HINT=http://qiita.com/usagi/items/2623145f22faf54b99e0

set DOT_DIR=%~dp0
echo DOT_DIR: %DOT_DIR%
echo USER_PROFILE: %USERPROFILE%

cd %~dp0

:checkMandatoryLevel
REM ▼管理者として実行されているか確認 START
for /f "tokens=1 delims=," %%i in ('whoami /groups /FO CSV /NH') do (
    if "%%~i"=="BUILTIN\Administrators" set ADMIN=yes
    if "%%~i"=="Mandatory Label\High Mandatory Level" set ELEVATED=yes
)

if "%ADMIN%" neq "yes" (
    echo このファイルは管理者権限での実行が必要です{Administratorsグループでない}
   if "%1" neq "/R" goto runas
   goto exit1
)
if "%ELEVATED%" neq "yes" (
    echo このファイルは管理者権限での実行が必要です{プロセスが昇格されていない}
   if "%1" neq "/R" goto runas
   goto exit1
)
REM ▲管理者として実行されているか確認 END


:admins
    echo on
    REM ▼管理者として実行したいコマンド START
    REM ### ~/.
    REM ## ruby
    del %USERPROFILE%\.gemrc
    mklink %USERPROFILE%\.gemrc %DOT_DIR%\gemrc
    REM ### .config
    mkdir %USERPROFILE%\.config
    REM # git
    rmdir %USERPROFILE%\.config\git
    mklink /D %USERPROFILE%\.config\git %DOT_DIR%\git
    call tools\win\touch.bat %USERPROFILE%\.config\git\config.local
    pause
    REM ▲管理者として実行したいコマンド END
    goto exit1

:runas
    REM ★管理者として再実行
    powershell -Command Start-Process -Verb runas "%0" -ArgumentList "/R"


:exit1