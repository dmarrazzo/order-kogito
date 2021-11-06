#!/bin/sh

if [ "$(uname)" == "Darwin" ]; then
   echo "DOCKER_GATEWAY_HOST=${host.docker.internal}" >> ".env"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
   echo "DOCKER_GATEWAY_HOST=172.17.0.1" >> ".env"
fi

docker-compose up