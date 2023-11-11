# TransIP DDNS Docker

Create a docker container for updating a TransIP DNS record with the current public IP address.
It monitors the current public IP address and when it changes it updates the DNS record hosted at TransIP.


# Using

This project uses:
- [IPInfo.io](https://ipinfo.io/) API for getting the public IP address
- [transip/tipctl](https://github.com/transip/tipctl) TransIP Control the official TransIP RestAPI CLI for setting the IP address
- [php:cli](https://hub.docker.com/_/php/) Official php:cli docker image


# Usage / Commands

## Build image

`docker build -t tipddns .`

## Run container

```
docker run -it \
  -e LOGINNAME=myusername \
  -e PRIVATEKEY="$(cat private.key)" \
  -e DOMAIN=mydomain.com \
  -e RECORD=@ \
  --rm --name tipddns tipddns
```
Replace `-it` for `-d` to run the container in the background

# Environment variables
