set PATH=C:\home\Toolz\xampp\php;%PATH%
php %~dp0\..\public\php\index.php batch
php %~dp0\..\public\php\index.php novels/search > %~dp0\..\public\partials\novels.json
cp %~dp0\..\public\partials\novels.json %~dp0\..\app\partials\novels.json
php %~dp0\..\public\php\index.php novels/search/past/7 > %~dp0\..\public\data\past-update.json
cp %~dp0\..\public\data\past-update.json %~dp0\..\app\data\past-update.json
