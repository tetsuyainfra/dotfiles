<# : �o�b�`�R�}���h(PowerShell�R�����g)�J�n
@echo off & setlocal
rem
rem     time.bat 
rem
rem     Created by earthdiver1
rem     �N���G�C�e�B�u�E�R�����Y �\�� - �p�� 4.0 ���� ���C�Z���X�̉��ɒ񋟂���Ă��܂��B
rem
rem -------------------------------------------------------------------------------
rem �ȉ���Powershell�X�N���v�g���o�b�`�t�@�C���̒��ɖ��ߍ��ނ��߂̃v���A���u���ł��B
set BATCH_ARGS=%*
if defined BATCH_ARGS set BATCH_ARGS=%BATCH_ARGS:"=\"%
endlocal & Powershell -NoP -C "&([ScriptBlock]::Create((${%~f0}|Out-String)))" %BATCH_ARGS%
exit/b
rem -------------------------------------------------------------------------------
: �o�b�`�R�}���h(PowerShell�R�����g)�I�� #>
Write-Host $Args
$cmd,$rest = $Args
Measure-Command { &$cmd $rest | Out-Host } | %{ Write-Host "`n$($_.TotalMilliseconds) msec" }
