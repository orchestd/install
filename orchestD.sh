#!/bin/bash

if [ ${1} == 'start' ]; then
  cd ~/orchestD/bin
  nohup ./orchestD &
  orchestDUrl=http://127.0.0.1:29000/
  xdg-open $orchestDUrl
elif [ ${1} == 'stop' ]; then
  killall -e orchestD
else
  echo "Usage: ./orchestD [start] OR [stop]"
  exit
fi

docker-compose -f integrations/docker-compose.yml $1
docker-compose -f docker-compose-orchestd.yml $1
