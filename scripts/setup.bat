@echo off
REM Setup script for API tests

echo 🚀 Setting up API Tests...

REM Check if Java is installed
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Java is not installed. Please install Java 17+ first.
    exit /b 1
)

echo ✅ Java version:
java -version

REM Check if Maven is installed
mvn --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Maven is not installed. Please install Maven 3.9+ first.
    exit /b 1
)

echo ✅ Maven version:
mvn --version

REM Create necessary directories
echo 📁 Creating directories...
if not exist "target" mkdir target
if not exist "target\surefire-reports" mkdir target\surefire-reports
if not exist "target\karate-reports" mkdir target\karate-reports
if not exist "target\site" mkdir target\site

echo ✅ Directories created successfully

REM Resolve dependencies
echo 📦 Resolving Maven dependencies...
mvn dependency:resolve

if %errorlevel% neq 0 (
    echo ❌ Failed to resolve dependencies
    exit /b 1
)

echo ✅ Dependencies resolved successfully

REM Compile the project
echo 🔨 Compiling project...
mvn compile

if %errorlevel% neq 0 (
    echo ❌ Failed to compile project
    exit /b 1
)

echo ✅ Project compiled successfully

REM Run code quality checks
echo 🔍 Running code quality checks...
mvn checkstyle:check
mvn spotbugs:check

if %errorlevel% neq 0 (
    echo ⚠️  Code quality checks failed. Please fix the issues.
    exit /b 1
)

echo ✅ Code quality checks passed

echo 🎉 Setup completed successfully!
echo.
echo Next steps:
echo 1. Start the demo app: docker run -d -p 3100:3100 --name demo-app automaticbytes/demo-app
echo 2. Run tests: mvn test
echo 3. View reports: mvn surefire-report:report

pause
