@ECHO OFF

IF "%~1" == "" (
	ECHO Usage: %~nx0 file-name.exe [/IEC]
	ECHO 	/IEC	Include file-name.exe.config ^(with Assembly Binding Redirect^)
	
	EXIT /B 1
)

IF NOT EXIST %1 (
	ECHO "File %1 not exists."
	
	EXIT /B 2
)

SET PROGRAM_NAME=%~n1
SET PROGRAM_PATH=%~dp1

SET OUTPUT_PATH=%~dp1

SET ZIP_PATH="C:\Program Files\7-Zip\7z.exe"
SET ZIP_NAME=latest.zip

SET OUTPUT_FILE=%OUTPUT_PATH%latest.zip
SET OUTPUT_VERSION_FILE=%OUTPUT_PATH%version

SET PROGRAM_STARTER_PATH="C:\docs\Projects.exe\ProgramStart\Release.%PROGRAM_NAME%\%PROGRAM_NAME%.exe"

ECHO Create zip for %PROGRAM_NAME%

IF EXIST %OUTPUT_FILE% DEL %OUTPUT_FILE%
IF EXIST %OUTPUT_VERSION_FILE% DEL %OUTPUT_VERSION_FILE%

FOR /F "tokens=* USEBACKQ" %%F IN (`get-version.cmd %1`) DO (
	IF %ERRORLEVEL% NEQ 0 (
		ECHO %%F
		
		GOTO error
	)
		
	SET VERSION=%%F
)

ECHO Version: %VERSION%

IF EXIST "%TMP%\%PROGRAM_NAME%" RD /S /Q "%TMP%\%PROGRAM_NAME%"

MD "%TMP%\%PROGRAM_NAME%\%VERSION%"

IF %ERRORLEVEL% NEQ 0 GOTO error

XCOPY /Y /Q /I "%PROGRAM_STARTER_PATH%" "%TMP%\%PROGRAM_NAME%"

XCOPY /Y /Q /S %PROGRAM_PATH%*.exe "%TMP%\%PROGRAM_NAME%\%VERSION%"
XCOPY /Y /Q /S %PROGRAM_PATH%*.dll "%TMP%\%PROGRAM_NAME%\%VERSION%"

IF "%~2"=="/IEC" XCOPY /Y /Q /I "%PROGRAM_PATH%*.exe.config" "%TMP%\%PROGRAM_NAME%\%VERSION%"

%ZIP_PATH% a -aoa -mx=9 %OUTPUT_FILE% "%TMP%\%PROGRAM_NAME%"

IF %ERRORLEVEL% NEQ 0 GOTO error

RD /S /Q "%TMP%\%PROGRAM_NAME%"

ECHO %VERSION% > %OUTPUT_VERSION_FILE%

ECHO.

ECHO Done. %OUTPUT_FILE% created.

GOTO exit

:error
	PAUSE
	
:exit
