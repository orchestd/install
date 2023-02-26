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
    show "please install golang\nhttps://go.dev/doc/install"
    exit
    fi

    goV=`go version | { read _ _ v _; echo ${v#go}; }`
    echo $goV
    if [[ "$goV" < "1.19.0" ]]; then
      echo "minimum supported version of golang is 1.19\nhttps://go.dev/doc/install"
      exit
    fi
}

function gitPrerequisites {
        which git
        if [ $? -ne 0 ]; then
        show "Please install git\nhttps://git-scm.com/downloads"
        exit
        fi
}

function dockerPrerequisites {
      which docker
      if [ $? -ne 0 ]; then
      show "orchestd uses Docker"
      exit
      fi

      docker -v
}

function dockerComposePrerequisites {
      which docker-compose
      if [ $? -ne 0 ]; then
      show "orchestd uses docker-compose"
      exit
      fi

      docker-compose version
}

function mongoDBPrerequisites {
      which mongo
      if [ $? -ne 0 ]; then
      show "for best experience, we advise you also install Mongo db tools\nhttps://www.mongodb.com/docs/mongodb-shell/install/"
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
