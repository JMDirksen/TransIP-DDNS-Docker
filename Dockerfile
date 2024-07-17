FROM php:cli-alpine

RUN apk add -U --no-cache \
    tzdata \
    curl

RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

COPY root/ /

WORKDIR /app
RUN chmod +x ./run.sh
ADD --chmod=755 https://github.com/transip/tipctl/releases/latest/download/tipctl.phar tipctl.phar

CMD /app/run.sh