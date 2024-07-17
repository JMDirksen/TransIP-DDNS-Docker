#!/bin/sh

echo "$(date +'%Y-%m-%d %T'): Started."

# Setup TransIP CLI
./tipctl.phar setup -n --loginName="$LOGINNAME" --apiPrivateKey="$(cat /app/private.key)" --apiUseWhitelist=false -vvv
if [ $? -ne 0 ]; then

    # TransIP setup failed
    echo "$(date +'%Y-%m-%d %T'): TransIP setup failed. Exiting."

    exit 1
fi

# Set default values
ROOTRECORD=@
SUBRECORD=*
TYPE=A
TTL=300
INTERVAL=300

LastSet="?"

while :
do
    # Get IP address
    CurrentIP="$(curl -sS --max-time 30 https://ipinfo.io/ip)"

    # Check IP address
    ipv4='^((25[0-5]|2[0-4]\d|1\d{2}|[1-9]?\d)\.){3}(25[0-5]|2[0-4]\d|1\d{2}|[1-9]?\d)$'
    ipv6='^(([0-9a-fA-F]{1,4}:){7}([0-9a-fA-F]{1,4}|:)|([0-9a-fA-F]{1,4}:){1,6}:|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}))?((25[0-5]|(2[0-4]|1?\d)?\d)\.){3}(25[0-5]|(2[0-4]|1?\d)?\d)|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1?\d)?\d)\.){3}(25[0-5]|(2[0-4]|1?\d)?\d))$'
    if ! [[ $CurrentIP =~ $ipv4 || $CurrentIP =~ $ipv6 ]]; then
        echo "$(date +'%Y-%m-%d %T'): Error getting IP address, response was: $CurrentIP."
        sleep 30
        continue
    fi

    # Check if IP has changed
    if [ "$CurrentIP" != "$LastSet" ]; then
        Success=true

        # Iterate over each domain in the array
        for DOMAIN in $(echo $DOMAINS | tr ',' ' '); do

            # Update subdomain DNS record, allow failures
            ./tipctl.phar domain:dns:updatednsentry "$DOMAIN" "$SUBRECORD" $TTL "$TYPE" "$CurrentIP"

            # Update root domain DNS record
            ./tipctl.phar domain:dns:updatednsentry "$DOMAIN" "$ROOTRECORD" $TTL "$TYPE" "$CurrentIP"

            # Check if the IP has been set for the root domain
            if [ $? == 0 ]; then

                # IP has been set for the current root domain
                echo "$(date +'%Y-%m-%d %T'): Set $ROOTRECORD.$DOMAIN -> $CurrentIP."
            else
                Success=false

                # Failed to set IP for the current root domain
                echo "$(date +'%Y-%m-%d %T'): Failed to set $ROOTRECORD.$DOMAIN -> $CurrentIP."
            fi
        done

        if [ $Success = true ]; then

            # Update LastSet only if all updates were successful
            LastSet=$CurrentIP
        fi

    elif [ $ALWAYSLOG = true ]; then

        # Log that no changes have been made
        echo "$(date +'%Y-%m-%d %T'): IP address not changed."
    fi

    sleep $(( $INTERVAL - 30 + $RANDOM % 30 ))
done