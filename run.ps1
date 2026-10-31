# Java Code Review & Quality Analyzer PowerShell Launcher
$env:JAVA_HOME = "C:\Users\Sakthi\.gemini\antigravity-ide\scratch\.tools\jdk21\jdk-21.0.12.1+1"
$env:M2_HOME = "C:\Users\Sakthi\.gemini\antigravity-ide\scratch\.tools\maven\apache-maven-3.9.6"
$env:Path = "$env:JAVA_HOME\bin;$env:M2_HOME\bin;" + $env:Path

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  Java Code Review & Quality Analyzer" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "Java version:" -ForegroundColor Yellow
java -version
Write-Host "Maven version:" -ForegroundColor Yellow
mvn -version

Write-Host "`nStarting Application on http://localhost:8080 ..." -ForegroundColor Cyan
mvn spring-boot:run
