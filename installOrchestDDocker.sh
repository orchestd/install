#!/bin/bash

cd integrations
./install.sh
cd ..

reset;

origpath=$PWD
userPath=/home/$USER/orchestD

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

function requestGithubUser {
      show 'please type your github user, (github -> top right corner, "Signed in as xxx")'
          read -p '> ' gituser
}

function requestGithubEmail {
    show "please type your github email, e.g. mymail@gmail.com / mymail@mycompany.com"
        read -p "> " gitemail
}

function readGithubEmailFromEnv {
  show "checking git config user.email..."
  gitemail=$(git config user.email)
  if [ $? -ne 0 ]; then
  show "how do I find it ? https://github.com/settings/emails"
  requestGithubEmail
  fi
}

function readGithubUserFromEnv {
      show "checking git config user.name..."
      gituser=$(git config user.name)
        if [ $? -ne 0 ]; then
            requestGithubUser
        fi
}

function readGithubUrl {
    show "please type the github url you will be working on for this development project:
          (if its youre private github, its probably https://github/${gituser}, if its a company shared github, its probably something like https://github/mycompany)"
    read -p "> https://github/" resGitUrl
    gitUrl="https://github/$resGitUrl"
}

function checkGitCliSshKey {
isGithub=$(ssh -T git@github.com 2>&1)
if [[ $isGithub != *"Permission denied"* ]]; then
show " it looks like you dont have git cli ssh key, which is the secured way to connect to github how would you like to proceed ?"
show "[1]show me the bash script and I will run it  \n[2]I will do it manually"
read -p "> " INPSEL
case $INPSEL in
"1")
tempMail=$gitemail
if [[ $tempMail == "" ]]; then
tempMail="xxxx@gmail.com"
fi
show "ssh-keygen -t ed25519 -C ${tempMail}"
show 'Enter -> Enter (empty passphrase)
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519\n
echo copy this value $(cat ~/.ssh/id_ed25519.pub) to here:
https://github.com/settings/keys
under "new ssh key"'
show '###   When your done installing git cli ssh key, please press [enter]'
read -n 1 -s -r -p ""
;;
"2")
show "please follow \n
https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account"
show '###   When your done installing git cli ssh key, please press [enter]'
read -n 1 -s -r -p ""
;;
esac
fi
}

readGithubEmailFromEnv
readGithubUserFromEnv
readGithubUrl
checkGitCliSshKey

show "would you like to work with this git configuration:\nemail=$gitemail , user=$gituser"
show "[1]Yes\n[2]No"
    read -p "> " INPSEL
	case $INPSEL in
	    "1")
      printf "{\n\t\"server\":\"$gitUrl\",\n\t\"gitUser\":\"$gituser\",\n\t\"gitEmail\":\"$gitemail\",\n\t\"devBranch\": \"main\",\n\t\"lockedBranches\":[\"dev\",\"master\",\"main\"]\n}\n" > ${userPath}/settings/git.json
			;;
	    "2")
	    requestGithubEmail;
	    requestGithubUser;
			;;
	esac


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

printf "{\n\t\"server\":\"$gitUrl\",\n\t\"gitUser\":\"$gituser\",\n\t\"gitEmail\":\"$gitemail\",\n\t\"devBranch\": \"main\",\n\t\"lockedBranches\":[\"dev\",\"master\",\"main\"]\n}\n" > ${userPath}/settings/git.json

show "go to src folder"
cd $userPath/src
pwd

isClone=false
apispecs="apispecs"
if [ -d "${apispecs}" ];
then
    show "$apispecs repo exists."
    cd $apispecs
    git pull $gitUrl/$apispecs

else

while [[ $isClone = false ]]
do
       if git clone $gitUrl/$apispecs 4>&1; then
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

# copy install folder
mkdir -p $userPath/bin/install
cp -r docker-compose-orchestd.yml $userPath/bin
cp -r orchestd.sh $userPath/bin
cp -r integrations $userPath/bin/integrations

show "###  docker-compose run orchestD  ###"
docker-compose -f $userPath/bin/docker-compose-orchestd.yml up -d

settingspath=$userPath/bin/settings
if [ ! -d "${settingspath}" ];
then
  ln -s $userPath/settings $userPath/bin
fi

cd $userPath/bin/

pathAlreadyExists=$(grep '~/orchestD/bin' ~/.bashrc)
if [ ${#pathAlreadyExists} == 0 ]; then
  show "Adding path to ~/.bashrc"
  echo "" >> ~/.bashrc
  echo "# orchestd" >> ~/.bashrc
  echo 'export PATH=$PATH:~/orchestD/bin' >> ~/.bashrc
  source ~/.bashrc
fi

# set git config
git config user.email $gitemail
git config user.user $giteuser

nohup ./orchestD &

orchestDUrl=http://127.0.0.1:29000/
show "Installation successful. click $orchestDUrl to start working"
xdg-open $orchestDUrl
