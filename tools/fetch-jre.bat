@echo off
REM Download a portable JRE locally when the system Java is missing.
setlocal enabledelayedexpansion
set "ROOT_DIR=%~dp0.."
set "RUNTIME_DIR=%ROOT_DIR%\runtime"
set "JRE_VERSION=17"
set "TMP_ZIP=%TEMP%\openjdk17-jre.zip"

mkdir "%RUNTIME_DIR%" 2>nul

echo Downloading OpenJDK %JRE_VERSION%...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; $url='https://api.adoptium.net/v3/binary/latest/%JRE_VERSION%/ga/windows/x64/jdk/hotspot/normal/jre'; Invoke-WebRequest -Uri $url -OutFile '%TMP_ZIP%' -UseBasicParsing"

if not exist "%TMP_ZIP%" (
    echo Download failed. Please install Java 11+ manually or place a JRE in runtime\.
    exit /b 1
)

echo Extracting to %RUNTIME_DIR%...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; Expand-Archive -Path '%TMP_ZIP%' -DestinationPath '%RUNTIME_DIR%' -Force"

if exist "%RUNTIME_DIR%\bin\java.exe" (
    echo JRE ready in %RUNTIME_DIR%
    del /q "%TMP_ZIP%" >nul 2>nul
    exit /b 0
) else (
    echo Extraction did not produce a usable runtime. Please install Java manually.
    exit /b 1
)
