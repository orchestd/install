# orchestD Installation and Usage Manual
This manual describes installation and usage of orchestD.
<br /><br />
## Prerequisites
---
orchestD is currenctly supported on main linux distributions.

In order to run orchestD, have the following installed on your computer:
* [golang 1.19+](https://go.dev/doc/install)
* [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [Docker Engine](https://docs.docker.com/engine/install/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* [Goland IDE](https://www.jetbrains.com/go/)
  <br /><br />
## GitHub
---
Complete the following:
1. Configue git user email on your computer, [follow the process in this link](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-email-preferences/setting-your-commit-email-address#setting-your-email-address-for-every-repository-on-your-computer)
2. Sign in to your [github](https://github.com/) account
3. Create a **public** github repo named "**apispecs**", make sure you check "Add a README file". [this link will take you there](https://github.com/new?repo_name=apispecs)

Enable github access using ssh key, [follow the process in this link](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) or follow these steps:
1. Create an ssh key using your github account email by typing the following command, and hit "return" with no more details until the process ends:
    ```
    $ ssh-keygen -t ed25519 -C "your_github_account_email@somewhere.com"
    ```
2. Activate ssh agent and register the newly generated private key
    ```
    $ eval $(ssh-agent -s)
    $ ssh-add ~/.ssh/id_ed25519
    ```
3. Echo to console the generated public key
    ```
    $ cat ~/.ssh/id_ed25519.pub
    ```
4. Use the public key to create "New SSH Key" in your github account here:
   [https://github.com/settings/ssh/new](https://github.com/settings/ssh/new)
   <br /><br />

## Installation
---
Open a terminal, cd to the desired destination folder, clone the installtion repo and run the installer:
```
$ cd path/to/my/folder
$ git clone https://github.com/orchestd/install.git instal-orchestd
$ cd instal-orchestd
$ ./installOrchestDDocker.sh
```
<br/>

## Folders Created
---
The following folders will be generated in your user home folder ~
* ~/orchestD/bin - contains files orchestD requires for running
* ~/orchestD/src - this is the project root source, open this folder as project in GoLand IDE.
  <br /><br />

## Start, Stop
---
Once done, the orchestD process will run and serve UI from [http://localhost:29000/](http://localhost:29000/).

To stop orchestD
```
$ cd ~/orchestD/bin
$ ./orchestDRunner.sh stop
```

To start orchestD again
```
$ cd ~/orchestD/bin
$ ./orchestDRunner.sh start
```
<br />

## Happy Coding!
---
You are ready to go!

Go to  [https://www.orchestd.io/api-design](https://www.orchestd.io/api-design) for a complete tutorial to your first orchestD experience.
