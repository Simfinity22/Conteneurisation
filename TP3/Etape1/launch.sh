#!/bin/bash

docker network create tp3net

docker container run -d \
  --name script \
  --network tp3net \
  -v "$(pwd)/app:/app" \
  php:8.2-fpm


docker container run -d \
  --name http \
  --network tp3net \
  -p 8080:80 \
  -v "$(pwd)/app:/app" \
  -v "$(pwd)/nginx/default.conf:/etc/nginx/conf.d/default.conf" \
  nginx
