#!/bin/bash

cd ~/orchestD/bin

export ORCHESTD_REGISTRY=eu.gcr.io/orchestd-io
export HEILA_TYPE=HEAD
export HEILA_ENV=LOCAL
export GIN_MODE=release
export TAG=lastmerge
export DOCKER_NAME=orchestD

if [[ ${1} == 'start' ]]; then
  docker-compose -f integrations/docker-compose.yml $1
  docker-compose -f docker-compose-orchestd.yml $1
  nohup ./orchestD &
  orchestDUrl=http://127.0.0.1:29000/
  xdg-open $orchestDUrl
elif [[ ${1} == 'stop' ]]; then
  docker-compose -f integrations/docker-compose.yml $1
  docker-compose -f docker-compose-orchestd.yml $1
  killall -e orchestD
elif [[ ${1} == 'update' ]]; then
  export TAG=latest

DigestCurrent=$(docker images --digests eu.gcr.io/orchestd-io/servicebuilder --format "{{.Digest}} {{.Tag}}" | grep latest | awk  '{print $1}')

docker-compose -f docker-compose-orchestd.yml pull

DigestNew=$(docker images --digests eu.gcr.io/orchestd-io/servicebuilder --format "{{.Digest}} {{.Tag}}" | grep latest | awk  '{print $1}')

if [[ ${DigestCurrent} != ${DigestNew} ]]; then
  docker-compose -f docker-compose-orchestd.yml stop
  docker-compose -f docker-compose-orchestd.yml up -d
else
    echo "New version updated"
fi

else
  echo "Usage: ./orchestD [start] OR [stop] OR [update]"
  exit
fi
