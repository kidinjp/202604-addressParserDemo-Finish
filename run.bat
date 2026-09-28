@echo off
cd /d "%~dp0"
REM Lightweight startup: use bundled JRE if present, else system Java, else try to download a portable JRE
if exist ".\runtime\bin\java.exe" (
	set "JAVA_BIN=.\runtime\bin\java.exe"
) else (
	where java >nul 2>nul
	if %ERRORLEVEL% == 0 (
		set "JAVA_BIN=java"
	) else (
		echo No Java runtime found. Attempting to download a portable OpenJDK into .\runtime\
		call "%~dp0tools\fetch-jre.bat"
		if exist ".\runtime\bin\java.exe" (
			set "JAVA_BIN=.\runtime\bin\java.exe"
		) else (
			echo.
			echo Failed to obtain a Java runtime automatically.
			echo Please install Java 11+ or place a JRE in the runtime\ directory.
			pause
			exit /b 1
		)
	)
)

start "" cmd /k "%JAVA_BIN%" -jar addressParserDemo-0.0.1-SNAPSHOT.jar

timeout /t 3 /nobreak >nul

start "" http://localhost:9090