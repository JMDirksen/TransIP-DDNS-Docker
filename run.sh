#!/bin/bash

./tipctl.phar setup -n --apiUseWhitelist=false --loginName="$LOGINNAME" --apiPrivateKey="$PRIVATEKEY" -vvv
LastSet="?"

while :
do
    CurrentIP="$(curl -s ipinfo.io/ip)"
    if [ "$CurrentIP" != "$LastSet" ]
    then
        ./tipctl.phar domain:dns:updatednsentry $DOMAIN $RECORD $TTL $TYPE $CurrentIP
        LastSet=$CurrentIP
        echo "$(date +'%Y-%m-%d %T') Set $RECORD.$DOMAIN -> $CurrentIP"
    fi

    sleep $INTERVAL
done
