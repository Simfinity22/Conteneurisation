#!/bin/bash

set -e

docker rm -f http script data 2>/dev/null || true
docker network create tp3net 2>/dev/null || true

docker build -t php-mysqli ./script

docker run -d \
  --name script \
  --network tp3net \
  -v "$(pwd)/app:/app" \
  php-mysqli

docker run -d \
  --name http \
  --network tp3net \
  -p 8080:80 \
  -v "$(pwd)/app:/app" \
  -v "$(pwd)/nginx/default.conf:/etc/nginx/conf.d/default.conf:ro" \
  nginx:latest

docker run -d \
  --name data \
  --network tp3net \
  -e MARIADB_RANDOM_ROOT_PASSWORD=yes \
  -v "$(pwd)/data:/docker-entrypoint-initdb.d:ro" \
  mariadb:latest