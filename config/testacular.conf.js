// Testacular configuration
// Generated on Tue Sep 04 2012 15:07:16 GMT+0900 (東京 (標準時))


// base path, that will be used to resolve files and exclude
basePath = '../';


// list of files / patterns to load in the browser
files = [
  JASMINE,
  JASMINE_ADAPTER,
  'app/lib/angular/angular.js',
  'app/lib/jquery-1.9.1.min.js',
  'public/lib/vendor.min.js',
  'test/lib/angular/angular-mocks.js',
  'public/js/init.js',
  'public/js/app.js',
  'public/js/controllers.js',
  'public/js/directives.js',
  'public/js/filters.js',
  'public/js/services.js',
  'test/unit/*Spec.js'
];


// list of files to exclude
exclude = [

];


// test results reporter to use
// possible values: dots || progress
reporters = 'progress';


// web server port
port = 4444;


// cli runner port
runnerPort = 9101;


// enable / disable colors in the output (reporters and logs)
colors = true;


// level of logging
// possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
logLevel = LOG_INFO;


// enable / disable watching file and executing tests whenever any file changes
autoWatch = true;


// Start these browsers, currently available:
// - Chrome
// - ChromeCanary
// - Firefox
// - Opera
// - Safari
// - PhantomJS
browsers = ['PhantomJS'];

// If browser does not capture in given timeout [ms], kill it
captureTimeout = 5000;

// Continuous Integration mode
// if true, it capture browsers, run tests and exit
singleRun = false;
