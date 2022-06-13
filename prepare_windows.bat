@ECHO OFF

setlocal

@REM echo %~dp0
@REM "パスの最後に\が含まれているので注意"
SET DOT_DIR=%~dp0
SET DOTTER_LOCAL_SKEL=%DOT_DIR%.dotter\skel\local_windows.toml
SET DOTTER_LOCAL_FILE=%DOT_DIR%.dotter\local.toml

echo "DOT_DIR: %DOT_DIR%"
echo "DOTTER_LOCAL_SKEL: %DOTTER_LOCAL_SKEL%"
echo "DOTTER_LOCAL_FILE: %DOTTER_LOCAL_FILE%"

@pushd %DOT_DIR%

@REM ------------------------------------------------------------
@REM GIT_USERNAME
@REM ------------------------------------------------------------
for /f "usebackq delims=" %%A in (`git config --get user.name`) do set GOT_USERNAME=%%A

:INPUT_USERNAME
if defined GOT_USERNAME (
    echo "GOT_USERNAME: %GOT_USERNAME%"
) else (
    echo 定義されていません 指定してもらう
    SET /P GOT_USERNAME="git config user.name: "
)
IF "%GOT_USERNAME%"=="" GOTO :INPUT_USERNAME


@REM ------------------------------------------------------------
@REM GIT_EMAIL
@REM ------------------------------------------------------------
for /f "usebackq delims=" %%A in (`git config --get user.email`) do set GOT_EMAIL=%%A

:INPUT_EMAIL
if defined GOT_EMAIL (
    echo "GOT_EMAIL: %GOT_EMAIL%"
) else (
    echo 定義されていません 指定してもらう
    SET /P GOT_EMAIL="git config user.email: "
)
IF "%GOT_EMAIL%"=="" GOTO :INPUT_EMAIL


@ECHO ON
@REM ------------------------------------------------------------
@REM DOTFILEのデプロイ
@REM ------------------------------------------------------------

 @if not exist %DOTTER_LOCAL_FILE% (
   @REM "Windows用ローカルコンフィグをコピーする"
   copy %DOTTER_LOCAL_SKEL% %DOTTER_LOCAL_FILE%
 ) else (
   @echo "%DOTTER_LOCAL_FILE% が存在しています"
   @echo "dotterのOS毎のファイルコピーをスキップします"
 )

@REM "ドットファイルのコピー"
%DOT_DIR%dotter.exe deploy

@REM ------------------------------------------------------------
@REM ~/.config/git/config.localの設定
@REM ------------------------------------------------------------
SET HOME=%homedrive%%homepath%
git config -f %HOME%\.config/git/config.local user.name  %GOT_USERNAME%
git config -f %HOME%\.config/git/config.local user.email %GOT_EMAIL%


@popd

endlocal

@REM @REM バッチファイルの終了
@REM exit /b