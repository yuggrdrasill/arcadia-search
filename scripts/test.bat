set CHROME_BIN=%USERPROFILE%\Local Settings\Application Data\Google\Chrome\Application\chrome.exe
set PHANTOMJS_BIN=phantomjs
node %~dp0..\node_modules\testacular\bin\testacular start config/testacular.conf.js
