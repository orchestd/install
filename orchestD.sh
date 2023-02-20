#!/bin/bash

docker-compose -f integrations/docker-compose.yml $1
docker-compose -f docker-compose-orchestd.yml $1

if [ ${1} == 'start' ]; then
  cd ~/orchestD/bin
  nohup ./orchestD &
  orchestDUrl=http://127.0.0.1:29000/
  xdg-open $orchestDUrl
fi

if [ ${1} == 'stop' ]; then
  killall -e orchestD
fi