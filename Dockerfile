FROM php:cli
WORKDIR /root
COPY --chmod=700 run.sh .
ADD --chmod=700 https://github.com/transip/tipctl/releases/latest/download/tipctl.phar tipctl.phar
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

ENV LOGINNAME=myusername
ENV PRIVATEKEY=myprivatekey
ENV DOMAIN=mydomain.com
ENV RECORD=@
ENV TTL=300
ENV TYPE=A
ENV INTERVAL=300
ENV ALWAYSLOG=false

CMD ./run.sh
