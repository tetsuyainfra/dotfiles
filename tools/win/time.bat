<# : バッチコマンド(PowerShellコメント)開始
@echo off & setlocal
rem
rem     time.bat 
rem
rem     Created by earthdiver1
rem     クリエイティブ・コモンズ 表示 - 継承 4.0 国際 ライセンスの下に提供されています。
rem
rem -------------------------------------------------------------------------------
rem 以下はPowershellスクリプトをバッチファイルの中に埋め込むためのプリアンブルです。
set BATCH_ARGS=%*
if defined BATCH_ARGS set BATCH_ARGS=%BATCH_ARGS:"=\"%
endlocal & Powershell -NoP -C "&([ScriptBlock]::Create((${%~f0}|Out-String)))" %BATCH_ARGS%
exit/b
rem -------------------------------------------------------------------------------
: バッチコマンド(PowerShellコメント)終了 #>
Write-Host $Args
$cmd,$rest = $Args
Measure-Command { &$cmd $rest | Out-Host } | %{ Write-Host "`n$($_.TotalMilliseconds) msec" }
