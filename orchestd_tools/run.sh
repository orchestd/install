#!/bin/bash
export HEILA_TYPE=HEAD
export HEILA_ENV=LOCAL
export GIN_MODE=release
export TAG=latest

echo "###  docker-compose run DBs and tools  ###"
docker-compose -f docker-compose.yml up -d

exit
echo "### Done ###"

echo "###  docker-compose run orchestD  ###"
docker-compose -f docker-compose-orchestd.yml up -d

echo "### Done ###"
