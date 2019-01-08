@echo off
REM SHIFT-JIS/CRLF�ŕۑ����邱��

REM HINT=http://qiita.com/usagi/items/2623145f22faf54b99e0

set DOT_DIR=%~dp0
echo DOT_DIR: %DOT_DIR%
echo USER_PROFILE: %USERPROFILE%

cd %~dp0

:checkMandatoryLevel
REM ���Ǘ��҂Ƃ��Ď��s����Ă��邩�m�F START
for /f "tokens=1 delims=," %%i in ('whoami /groups /FO CSV /NH') do (
    if "%%~i"=="BUILTIN\Administrators" set ADMIN=yes
    if "%%~i"=="Mandatory Label\High Mandatory Level" set ELEVATED=yes
)

if "%ADMIN%" neq "yes" (
    echo ���̃t�@�C���͊Ǘ��Ҍ����ł̎��s���K�v�ł�{Administrators�O���[�v�łȂ�}
   if "%1" neq "/R" goto runas
   goto exit1
)
if "%ELEVATED%" neq "yes" (
    echo ���̃t�@�C���͊Ǘ��Ҍ����ł̎��s���K�v�ł�{�v���Z�X�����i����Ă��Ȃ�}
   if "%1" neq "/R" goto runas
   goto exit1
)
REM ���Ǘ��҂Ƃ��Ď��s����Ă��邩�m�F END


:admins
    echo on
    REM ���Ǘ��҂Ƃ��Ď��s�������R�}���h START
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
    REM ���Ǘ��҂Ƃ��Ď��s�������R�}���h END
    goto exit1

:runas
    REM ���Ǘ��҂Ƃ��čĎ��s
    powershell -Command Start-Process -Verb runas "%0" -ArgumentList "/R"


:exit1