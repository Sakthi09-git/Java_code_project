@echo off
setlocal
echo ========================================================
echo   Java Code Review & Quality Analyzer Launcher
echo ========================================================

REM Set JAVA_HOME and Maven paths if not in PATH
if not defined JAVA_HOME (
    if exist "C:\Users\Sakthi\.gemini\antigravity-ide\scratch\.tools\jdk21\jdk-21.0.12.1+1" (
        set "JAVA_HOME=C:\Users\Sakthi\.gemini\antigravity-ide\scratch\.tools\jdk21\jdk-21.0.12.1+1"
    )
)

if exist "C:\Users\Sakthi\.gemini\antigravity-ide\scratch\.tools\maven\apache-maven-3.9.6\bin" (
    set "PATH=%JAVA_HOME%\bin;C:\Users\Sakthi\.gemini\antigravity-ide\scratch\.tools\maven\apache-maven-3.9.6\bin;%PATH%"
) else (
    set "PATH=%JAVA_HOME%\bin;%PATH%"
)

echo Using Java:
java -version

echo.
echo Starting Spring Boot Application on http://localhost:8080 ...
echo Make sure MySQL is running in XAMPP (port 3306).
echo.

mvn spring-boot:run
pause
