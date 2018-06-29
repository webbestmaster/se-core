#!/usr/bin/env bash

clear
browser=$1

if [ -z "${browser}" ] ; then
    echo "You should pass a parameter: browser"
    exit 1
fi

now="$(date +'%Y-%m-%d-%H-%M-%S')"
reportsFolder=./reports
reportName=auto-test-$browser--$now

mocha ./test/*.test.js --reporter mochawesome --reporter-options reportDir=$reportsFolder/$reportName,reportFilename=$reportName,reportTitle="Auto Test $browser - $now",inlineAssets=false


#unamestr=`uname`
#reportPath="./$reportsFolder/auto-test-$now/$reportName.html"
#if [[ "$unamestr" == 'Darwin' ]]; then # detect MacOS
#   open $reportPath
#elif [[ "$unamestr" == 'Linux' ]]; then # detect Linux
#   xdg-open $reportPath
#fi
