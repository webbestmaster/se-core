#!/usr/bin/env bash

phoneListFileName=./phone-list.txt
deviceIds=""

while read -r line
do
    if [[ -n $line && "$line" != "#"* ]]; then
        deviceIds+=$line" "
    fi
done < $phoneListFileName

pathToAdb="~/Android/Sdk/platform-tools/adb"

echo "Unbind all devices"

( exec "${pathToAdb}" forward --remove-all )

deviceIds=($deviceIds)
startPortNumber=8000

for deviceId in "${deviceIds[@]}";
do

    startPortNumber=$((startPortNumber + 1))
    serverPort=$startPortNumber

    # bind device
    echo "Prepare device - deviceId: ${deviceId} to tcp: ${serverPort}"
    ( exec "${pathToAdb}" -s "${deviceId}" forward tcp:"${serverPort}" tcp:8080 )

    # press home button
    echo "Go to home"
    ( exec "${pathToAdb}" -s "${deviceId}" shell input keyevent 3)

    # close and clear app
    echo "Close and clear app"
    ( exec "${pathToAdb}" -s "${deviceId}" shell pm clear org.openqa.selenium.android.app)

    # run app
    echo "Run app"
    ( exec "${pathToAdb}" -s "${deviceId}" shell am start -a android.intent.action.MAIN -n org.openqa.selenium.android.app/.MainActivity)

    ./run-mobile-test.sh $deviceId $serverPort # &
done
