#!/bin/bash

export ORCHESTD_REGISTRY=eu.gcr.io/orchestd-io
export HEILA_TYPE=HEAD
export HEILA_ENV=LOCAL
export GIN_MODE=release
export TAG=lastmerge
export DOCKER_NAME=orchestD

if [ ${1} == 'start' ]; then
  docker-compose -f integrations/docker-compose.yml $1
  docker-compose -f docker-compose-orchestd.yml $1
  cd ~/orchestD/bin
  nohup ./orchestD &
  orchestDUrl=http://127.0.0.1:29000/
  xdg-open $orchestDUrl
elif [ ${1} == 'stop' ]; then
  docker-compose -f integrations/docker-compose.yml $1
  docker-compose -f docker-compose-orchestd.yml $1
  killall -e orchestD
else
  echo "Usage: ./orchestD [start] OR [stop]"
  exit
fi
