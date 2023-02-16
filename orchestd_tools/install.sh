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


# Instal Docker
show "cheking Docker.."
docker -v
if [ $? -ne 0 ]; then
show "Need to install Docker"
show "do you want install?\n[1]Yes\n[2]No"
    read -p "> " INPSEL
	case $INPSEL in
	    "1")
            show "### Installing docker  ####"
            ./install_docker_ubuntu.sh
			;;
	    "2")
            exit
			;;
	esac
fi
show "done"

# Install docker-compose
show "docker-compose.."
docker-compose version
if [ $? -ne 0 ]; then
show "Need to install docker-compose"
show "do you want install?\n[1]Yes\n[2]No"
    read -p "> " INPSEL
	case $INPSEL in
	    "1")
            show "### Installing docker-compose  ####"
            sudo curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
            sudo chmod +x /usr/local/bin/docker-compose
            sudo docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions
			;;
	    "2")
            exit
			;;
	esac
fi
show "done"


# Install mongo client
show "MongoDB"
ls /etc/apt/sources.list.d | grep mongodb-org-
if [ $? -ne 0 ]; then
show "Need to install MongoDB"
show "do you want install?\n[1]Yes\n[2]No"
    read -p "> " INPSEL
	case $INPSEL in
	    "1")
            wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
            echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
            sudo apt-get update
            sudo apt-get install -y  mongodb-org-shell
            sudo apt-get install -y mongodb-database-tools
			;;
	    "2")
            exit
			;;
	esac
fi


./run.sh
