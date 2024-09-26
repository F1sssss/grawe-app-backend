FROM redis:7.2-alpine

WORKDIR /redis

USER root

#COPY redis.conf /usr/local/etc/redis/redis.conf

COPY ./redis/init.sh ./

RUN chmod +x init.sh