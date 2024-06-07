@ECHO OFF

IF "%~1" == "" (
	ECHO "Usage: %~nx0 file-name.exe"
	
	EXIT /B 1
)

IF NOT EXIST %1 (
	ECHO "File %1 not exists."
	
	EXIT /B 2
)

powershell -NoLogo -NoProfile -Command "$ErrorActionPreference = 'Stop'; $version = (Get-Item -Path '%1').VersionInfo.FileVersion; $version; trap { Write-Host $Error[0]; exit 42; }"

IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%