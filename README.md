# TransIP DDNS Docker

Create a docker container for updating a TransIP DNS record with the current public IP address.
It monitors the current public IP address and when it changes it updates the DNS record hosted at TransIP.
It does this every 4:30 to 5:00 minutes to make sure the DNS record is always up-to-date.


# Using

This project uses:
- [IPInfo.io](https://ipinfo.io/) API for getting the public IP address
- [transip/tipctl](https://github.com/transip/tipctl) TransIP Control the official TransIP RestAPI CLI for setting the IP address
- [php:cli-alpine](https://hub.docker.com/_/php/) Official php:cli-alpine docker image


# Usage / Commands

## Build or pull image

`docker build -t jmdirksen/tipddns:latest .`  
or  
`docker pull jmdirksen/tipddns:latest`  

## Run container

Put your private key in a file called `private.key` and run the container with the following command:
```
docker run -it \
  -e LOGINNAME=myusername \
  -e DOMAINS=mydomain.com,myotherdomain.com \
  --restart unless-stopped --name tipddns jmdirksen/tipddns:latest
```
Replace `-it` for `-itd` to run the container in the background (or detach from the running container by pressing Ctrl+P followed by Ctrl+Q)

## Show logs

`docker logs tipddns`


# Environment variables

Variable | Default value | Description
--|--|--
**LOGINNAME** | myusername | Your TransIP username
**DOMAINS** | mydomain.com,myotherdomain.com | The domainnames registered at TransIP from which you want to update a record
RECORD | @ | The DNS record name for which to change the IP address (@, *, www, etc.)
TTL | 300 | The Time-To-Live of the DNS record, defaults to 5 minutes
TYPE | A | The type of the record to update
INTERVAL | 300 | The interval in seconds before checking again if the public IP has changed
ALWAYSLOG | false | When set to true, log wil show IP has been checked but DNS did not need to be updated

***BOLD**: These variables must be changed, the other variables could be left at their defaults.*
