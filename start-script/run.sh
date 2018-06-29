#!/usr/bin/env bash

browser=$1
browserServerPort=4444

case $browser in
    chrome | opera | ff)
        echo $browser browser
        BROWSER_NAME=$browser SE_SERVER_PORT=$browserServerPort IS_MOBILE="" ./run-pc-test.sh $browser
    ;;

    android)
        echo android browser
        BROWSER_NAME=$browser IS_MOBILE=1 ./run-mobile-list-test.sh
    ;;

    *)
        echo pass browser type - chrome, ff, opera or android
esac

