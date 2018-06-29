#!/usr/bin/env bash

# parameters $deviceId devicePort

deviceId=$1
serverPort=$2

if [ -z "${serverPort}" ] ; then
    echo "You should pass two parameters: deviceId and serverPort"
    exit 1
fi

now="$(date +'%Y-%m-%d-%H-%M-%S')"
reportsFolder=./reports
reportName=auto-test-$deviceId--$now

SE_SERVER_PORT=$serverPort mocha ./test/*.test.js --reporter mochawesome --reporter-options reportDir=$reportsFolder/$reportName,reportFilename=$reportName,reportTitle="Auto Test $deviceId - $now",inlineAssets=false

#unamestr=`uname`
#reportPath="$reportsFolder/$reportName.html"
#if [[ "$unamestr" == 'Darwin' ]]; then # detect MacOS
#   open $reportPath
#elif [[ "$unamestr" == 'Linux' ]]; then # detect Linux
#   xdg-open $reportPath
#fi

exit 0
