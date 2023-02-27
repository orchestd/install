#!/bin/bash
export HEILA_TYPE=HEAD
export HEILA_ENV=LOCAL
export GIN_MODE=release
export TAG=latest

function show {
	if [ "$1" == "-e" ]
	then
	fnt=`tput setaf 7;tput setab 1;`
	txt="$2"
	else
	fnt=`tput setaf 3;`
	txt="$1"
	fi
	echo ""
	echo -e "${fnt}${txt}`tput sgr0`"
}

# checking Prerequisites
function goPrerequisites {
    which go
    if [ $? -ne 0 ]; then
    show "Please install golang\n   https://go.dev/doc/install"
    exit
    fi

    goV=`go version | { read _ _ v _; echo ${v#go}; }`
    echo $goV
    if [[ "$goV" < "1.19.0" ]]; then
      echo "Minimum supported version of golang is 1.19, Please update\nhttps://go.dev/doc/install"
      exit
    fi
}

function gitPrerequisites {
        which git
        if [ $? -ne 0 ]; then
        show "Please install git\n   https://git-scm.com/downloads"
        exit
        fi
}

function dockerPrerequisites {
      which docker
      if [ $? -ne 0 ]; then
      show "Please install Docker\n   https://docs.docker.com/engine/install/"
      exit
      fi

      docker -v
}

function dockerComposePrerequisites {
      which docker-compose
      if [ $? -ne 0 ]; then
      show "Please install Docker compose\n   https://docs.docker.com/compose/install/"
      exit
      fi

      docker-compose version
}

function mongoDBPrerequisites {
      which mongo
      if [ $? -ne 0 ]; then
      show "For best experience, we advise you also install Mongo db tools\n   https://www.mongodb.com/docs/mongodb-shell/install/"
      fi
      mongo -version
}

goPrerequisites
gitPrerequisites
dockerPrerequisites
dockerComposePrerequisites
mongoDBPrerequisites

echo "###  docker-compose run DBs and tools  ###"
docker-compose -f docker-compose.yml up -d
