#!/bin/bash

origpath=$PWD

#report installation start
startId=$(date +%s)
d=$(date '+%Y-%m-%d-%H:%M:%S')
event='{"eventType":"start","eventsData":{"Len":"'${startId}'","Checksum":"0"},"session":"install","timestamp":"'${d}'"}'
curl -X POST "https://stats.orchestd.io/stats" -d "${event}" > /dev/null 2>&1

cd integrations
./install.sh
cd ..

reset;

userPath=/home/$USER/orchestd

export ORCHESTD_REGISTRY=eu.gcr.io/orchestd-io
export HEILA_TYPE=HEAD
export HEILA_ENV=LOCAL
export GIN_MODE=release
export TAG=latest
export DOCKER_NAME=orchestd

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
      show 'Please type your github user, (how do I find it ? github.com -> top right corner, "Signed in as xxx"):'
          read -p '> ' gituser
}

function requestGithubEmail {
    show 'Please provide the email associated with your github account  (how do I find it ? https://github.com/settings/emails")'
    read -p "> " gitemail
}

function requestGithubUrl {
    show "please type the github url you will be working on for this development project:
          (if its youre private github, its probably https://github/${gituser}, if its a company shared github, its probably something like https://github/mycompany)"
    read -p "> https://github.com/" resGitUrl
    gitUrl="https://github.com/$resGitUrl"
}

function readGitFromEnv {
      #show "checking git config user.email..."
      gitemail=$(git config user.email)
      #show "checking git config user.name..."
      gituser=$(git config user.name)
}


function ShowDocHowAddNewSShKey {
isDone=false
while [[ $isDone = false ]]
do
show "It looks like you dont have git cli ssh key, which is the secured way to connect to github. how would you like to proceed ?"
show "[1] Auto create ssh key, and I will copy it to github  \n[2] Take me to github docs that explains how to configure"
read -p "> " INPSEL
case $INPSEL in
"1")
reset

ssh-keygen -t ed25519 -N '' -f ~/.ssh/orchestd -C ${gitemail} <<< y

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/orchestd
reset
hash=$(cat ~/.ssh/orchestd.pub)

echo "Host orchestd.github.com
  Hostname github.com
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/orchestd" > config

show "Your ssh key is:\n
${hash}\n
 Please copy this value to https://github.com/settings/keys
	under 'new ssh key' "
show "###   When your done installing git cli ssh key, please press [enter]"
read -n 1 -s -r -p ""
  isDone=true
;;
"2")
show "please follow \n
https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account"
show '###   When your done installing git cli ssh key, please press [enter]'
read -n 1 -s -r -p ""
  isDone=true
;;
*)
show "Unknown command line argument $1"
show "[1] Yes\n[2] No\n"
;;
esac
done
}

function checkSSHKeyGitHubEmail {
isEmail=$(cat ~/.ssh/* | grep $gitemail)
if [[ "$isEmail" == "" ]]; then
ShowDocHowAddNewSShKey
fi
}

function confirmeGitParams {
    isDoneGitConfiguration=false
    while [[ $isDoneGitConfiguration = false ]]
    do
    show "would you like to work with this git configuration:\n\n     email=$gitemail \n     user=$gituser"
    show "[1] Yes-Use these setting\n[2] No-I want to use a different email and user"
        read -p "> " INPSEL
    	case $INPSEL in
    	    "1")
            isDoneGitConfiguration=true
    			;;
    	    "2")
    	    requestGithubEmail
    	    requestGithubUser
    	    isDoneGitConfiguration=true
    			;;
    	   *)
         show "Unknown command line argument $1"
        ;;
    	esac
    done
}

readGitFromEnv

if [[ "$gitemail" == "" || "$gituser" == "" ]];
then
  	requestGithubEmail
  	requestGithubUser
 else
   confirmeGitParams
fi
requestGithubUrl


if [ ! -d "${userPath}" ];
then

  mkdir -p ${userPath}

  show "create src folder"
  mkdir -p ${userPath}/src

  show "settings folder"
  mkdir -p ${userPath}/settings

  show "bin folder"
  mkdir ${userPath}/bin

  show "Log folder"
  mkdir -p ${userPath}/bin/Log

fi

printf "{\n\t\"server\":\"$gitUrl\",\n\t\"gitUser\":\"$gituser\",\n\t\"gitEmail\":\"$gitemail\",\n\t\"devBranch\": \"main\",\n\t\"lockedBranches\":[\"dev\",\"master\",\"main\"]\n}\n" > ${userPath}/settings/git.json

#show "go to src folder"
cd $userPath/src

#show "create git env"
fileGitName=".gitconfig"
printf "[user]\n" > $fileGitName
printf "\tname = $gituser\n" >> $fileGitName
printf "\temail = $gitemail\n\n" >> $fileGitName
printf '[url "ssh://git@github.com/"]' >> $fileGitName
printf "\n\tinsteadOf = https://github.com/\n" >> $fileGitName

printf "[includeIf \"gitdir:$userPath/src/\"]\n" >> ~/.gitconfig
printf "path = $userPath/src/"$fileGitName"\n" >> ~/.gitconfig

checkSSHKeyGitHubEmail

isClone=false
apispecs="apispecs"
if [ -d "${apispecs}" ];
then
    show "$apispecs repo exists."
else
while [[ $isClone = false ]]
do
    if git clone $gitUrl/$apispecs > /dev/null 2>&1; then
    	cd $apispecs
    	README="README.md"
    	if [ ! -f "${README}" ]; then
    	   echo "apispecs" > $README
    	   git add .
    	   git commit -m "initial commit"
    	   git push
    	fi
    isClone=true
      else
    reset
    show "In order to work on a project and keep track on your specs, you need to create an 'apispecs' repo on your github accout"
    show "*** and make sure to check the option 'Add a README file' ***"
    show "Please open this link https://github.com/new?repo_name=$apispecs to create repo"
    show '###   When your done create repo, please press [enter]'
    read -n 1 -s -r -p ""
    fi
done
fi

cd $origpath

# copy install folder
mkdir -p $userPath/bin/install
cp -r docker-compose-orchestd.yml $userPath/bin
cp -r orchestd.sh $userPath/bin
cp -r integrations $userPath/bin/integrations

cd $userPath/bin/
show "###  docker-compose run orchestD  ###"
docker-compose -f docker-compose-orchestd.yml up -d

settingspath=$userPath/bin/settings
if [ ! -d "${settingspath}" ];
then
  ln -s $userPath/settings $userPath/bin
fi

pathAlreadyExists=$(grep '~/orchestd/bin' ~/.bashrc)
if [ ${#pathAlreadyExists} == 0 ]; then
  show "Adding path to ~/.bashrc"
  echo "" >> ~/.bashrc
  echo "# orchestd" >> ~/.bashrc
  echo 'export PATH=$PATH:~/orchestd/bin' >> ~/.bashrc
  source ~/.bashrc
fi

nohup ./devplatform &
sleep 1
reset
orchestDUrl=http://127.0.0.1:29000/
show "Installation successful, and service is now running.

to stop the service
  orchestd.sh stop

to start the service
  orchestd.sh start
to update to latest version
  orchestd.sh update


browse to $orchestDUrl to begin your journey!"


#report installation end
d=$(date '+%Y-%m-%d-%H:%M:%S')
event='{"eventType":"end","eventsData":{"Len":"'${startId}'","Checksum":"0"},"session":"install","timestamp":"'${d}'"}'
curl -X POST "https://stats.orchestd.io/stats" -d "${event}" > /dev/null 2>&1

xdg-open $orchestDUrl 2> /dev/null
