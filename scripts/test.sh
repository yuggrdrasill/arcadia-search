#!/bin/bash

BASE_DIR=`dirname $0`

echo ""
echo "Starting Testacular Server (http://vojtajina.github.com/testacular)"
echo "-------------------------------------------------------------------"

$BASE_DIR/../node_modules/.bin/testacular start $BASE_DIR/../config/testacular.conf.js $*