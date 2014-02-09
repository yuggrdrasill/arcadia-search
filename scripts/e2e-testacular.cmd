@echo off
REM Windows script for running e2e tests
REM You have to run server and capture some browser first
REM
REM Requirements:
REM - NodeJS (http://nodejs.org/)
REM - Testacular (npm install -g testacular)

REM Windows XP Chrome
set CHROME_BIN=%USERPROFILE%\Local Settings\Application Data\Google\Chrome\Application\chrome.exe
set PHANTOMJS_BIN=phantomjs
set BASE_DIR=%~dp0

@IF EXIST "%BASE_DIR%..\node_modules\testacular\bin\testacular" (
  node "%BASE_DIR%..\node_modules\testacular\bin\testacular" start "%BASE_DIR%..\config\e2e.testacular.conf.js"
) ELSE (
  testacular start "%BASE_DIR%..\config\e2e.testacular.conf.js"
)