#!/bin/bash

# Setup
./tipctl.phar setup -n --apiUseWhitelist=false --loginName="$LOGINNAME" --apiPrivateKey="$PRIVATEKEY" -vvv
LastSet="?"

while :
do
    # Get IP address
    CurrentIP="$(curl -s ipinfo.io/ip)"
    
    # Check IP address
    ipv4='^((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])$'
    ipv6='^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$'
    if ! [[ $CurrentIP =~ $ipv4 || $CurrentIP =~ $ipv6 ]]; then
        echo "$(date +'%Y-%m-%d %T') Error getting IP address, response was: $CurrentIP"
        sleep $INTERVAL
        continue
    fi

    # Check if IP has changed
    if [ "$CurrentIP" != "$LastSet" ]; then
        
        # Update DNS record
        ./tipctl.phar domain:dns:updatednsentry $DOMAIN $RECORD $TTL $TYPE $CurrentIP
        if [ $? == 0 ]; then

            # IP has been set
            LastSet=$CurrentIP
            echo "$(date +'%Y-%m-%d %T') Set $RECORD.$DOMAIN -> $CurrentIP"

        fi
        
    fi

    sleep $INTERVAL
done
