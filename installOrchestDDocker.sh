#!/bin/bash

cd integrations
./install.sh
cd ..

reset;

origpath=$PWD

export ORCHESTD_REGISTRY=eu.gcr.io/orchestd-io
export HEILA_TYPE=HEAD
export HEILA_ENV=LOCAL
export GIN_MODE=release
export TAG=lastmerge
export DOCKER_NAME=orchestD

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

function installSshKey() {
    how " it looks like you dont have git cli ssh key, which is the secured way to connect to github how would you like to proceed ?"
    show "[1]show me the bash script and I will run it  \n[2]I will do it manually"
        read -p "> " INPSEL
    	case $INPSEL in
    	    "1")
    	    show 'ssh-keygen -t ed25519 -C \"xxxx@gmail.com\"\n
    	    Enter -> Enter (empty passphrase)\n
    	    eval \"$(ssh-agent -s)\"\n
    	    ssh-add ~/.ssh/id_ed25519\n\n
    	    echo copy this value $(cat ~/.ssh/id_ed25519.pub) to here:\n
    	    https://github.com/settings/keys\n
    	    under \"new ssh key\"\n'
          exit
    			;;
    	    "2")
          show "please follow \n
          https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account"
          exit
          ;;
    	esac
}

#  make sure you have an active git user on either GH or BBKT
show "checking git config user.email:"
git config user.email
if [ $? -ne 0 ]; then
show "Need to config git  user.email"
show "Show you how?\n[1]Yes\n[2]No"
    read -p "> " INPSEL
	case $INPSEL in
	    "1")
            show "https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-email-preferences/setting-your-commit-email-address#setting-your-email-address-for-every-repository-on-your-computer"
            exit
			;;
	    "2")
            exit
			;;
	esac
fi

  isGithub=$(ssh -T git@github.com 2>&1)
            if [[ $isGithub != *"Permission denied"* ]]; then
            show " please type your github user (not email), i.e. if your github path is \n
            https://github.com/leonardo-da-vinci \n
            please type: \n\n
            leonardo-da-vinci"
              read -p '> ' GITUSER
            else
              installSshKey
            fi

GITPATH="https://github.com/$GITUSER"

userPath=/home/$USER/orchestD

if [ ! -d "${userPath}" ];
then

  mkdir -p ${userPath}

  show "log folder"
  mkdir -p ${userPath}/log

  show "create src folder"
  mkdir -p ${userPath}/src

  show "settings folder"
  mkdir -p ${userPath}/settings

  show "bin folder"
  mkdir ${userPath}/bin

fi

printf "{\n\t\"server\":\"$GITPATH\",\n\t\"devBranch\": \"main\",\n\t\"lockedBranches\":[\"dev\",\"master\",\"main\"]\n}\n" > ${userPath}/settings/git.json

show "go to src folder"
cd $userPath/src
pwd

isClone=false
apispecs="apispecs"
if [ -d "${apispecs}" ];
then
    show "$apispecs repo exists."
    cd $apispecs
    git pull $GITPATH/$apispecs

else

while [[ $isClone = false ]]
do
       if git clone $GITPATH/$apispecs 4>&1; then
          isClone=true
       else
                 show "Open this link https://github.com/new?repo_name=$apispecs and create repo"
                 show "Have you created spispecs repo? \n[1] Yes\n[2] No\n"
                  read -p "> " ANS
                  case $ANS in
            "1")
                show "ok, let's try again..."
                        ;;
            "2")
            exit
                        ;;
        esac
       fi
done
fi



cd $origpath
show "###  docker-compose run orchestD  ###"
docker-compose -f docker-compose-orchestd.yml up -d

settingspath=$userPath/bin/settings
if [ ! -d "${settingspath}" ];
then
  ln -s $userPath/settings $userPath/bin
fi


cd $userPath/bin/

pathAlreadyExists=$(grep '~/orchestd/bin' ~/.bashrc)
if [ ${#pathAlreadyExists} == 0 ]; then
  show "Adding path to ~/.bashrc"
  echo "" >> ~/.bashrc
  echo "# orchestd" >> ~/.bashrc
  echo 'export PATH=$PATH:~/orchestd/bin' >> ~/.bashrc
  source ~/.bashrc
fi

nohup ./orchestD &

orchestDUrl=http://127.0.0.1:29000/
show "Installation successful. click $orchestDUrl to start working"
xdg-open $orchestDUrl
