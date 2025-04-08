# TransIP DDNS Docker

Create a docker container for updating a TransIP DNS record with the current public IP address.
It monitors the current public IP address and when it changes it updates the DNS record hosted at TransIP.


# Using

This project uses:
- [IPInfo.io](https://ipinfo.io/) API for getting the public IP address
- [transip/tipctl](https://github.com/transip/tipctl) TransIP Control the official TransIP RestAPI CLI for setting the IP address
- [php:cli](https://hub.docker.com/_/php/) Official php:cli docker image


# Usage / Commands

## Build or pull image

`docker build -t jmdirksen/tipddns:latest .`  
or  
`docker pull jmdirksen/tipddns:latest`  

## Run container

Example loading private key from file 'private.key':
```
docker run -it \
  -e LOGINNAME=myusername \
  -e PRIVATEKEY="$(cat private.key)" \
  -e DOMAIN=mydomain.com \
  -e RECORD=@ \
  --restart unless-stopped --name tipddns jmdirksen/tipddns:latest
```
Replace `-it` for `-itd` to run the container in the background (or detach from the running container by pressing Ctrl+P followed by Ctrl+Q)

## Show logs

`docker logs tipddns`


# Environment variables

Variable | Default value | Description
--|--|--
**LOGINNAME** | myusername | Your TransIP username
**PRIVATEKEY** | myprivatekey | The private key from the key-pair generated at the TransIP API settings. See run example above when the key is stored in a file named 'private.key'
**DOMAIN** | mydomain.com | The domainname registered at TransIP from which you want to update a record
RECORD | @ | The DNS record name for which to change the IP address (@, www, etc.). For wildcard (*) use 'wildcard'.
TTL | 300 | The Time-To-Live of the DNS record, defaults to 5 minutes
TYPE | A | The type of the record to update
INTERVAL | 300 | The interval in seconds before checking again if the public IP has changed
ALWAYSLOG | false | When set to true, log wil show IP has been checked but DNS did not need to be updated

***BOLD**: These variables must be changed, the other variables could be left at their defaults.*
