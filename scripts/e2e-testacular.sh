#!/bin/bash
export PhantomJS=phantomjs
BASE_DIR=`dirname $0`

echo ""
echo "Starting Testacular Server (http://vojtajina.github.com/testacular)"
echo "-------------------------------------------------------------------"

if [ -x "testacular" ]; then
  testacular start $BASE_DIR/../config/testacular-e2e.conf.js $*
else 
  node $BASE_DIR/../node_modules/testacular/bin/testacular start config/e2e.testacular.conf.js
fi
