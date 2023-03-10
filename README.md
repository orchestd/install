# orchestD Installation and Manual
This manual describes installation and basic operation of orchestD.

## Prerequisites 

orchestD is currenctly supported on main linux distributions.

In order to run orchestD, have the following installed on your computer:
* [golang 1.19+](https://go.dev/doc/install)    
* [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [Docker Engine](https://docs.docker.com/engine/install/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* Recommended - [Goland IDE](https://www.jetbrains.com/go/) or [Visual Studio Code with go plugin](https://learn.microsoft.com/en-us/azure/developer/go/configure-visual-studio-code)
* Optional - [Mongo client tools](https://www.mongodb.com/docs/database-tools/installation/installation-linux/) - If you want to use cache storage

Notice, while orchestD is running, it will create a lookup server on your local http port (80)

## GitHub

If your git cli is not configured to use github, please complete the [github cli connection process](https://github.com/orchestd/install/tree/main/connect-github.md)

Please create a github repo where all your specs will be saved : https://github.com/new?repo_name=apispecs

## Installation

Open a terminal, cd to the desired destination folder, clone the installtion repo and run the installer:
```
#cd path/to/folder
git clone https://github.com/orchestd/install.git install-orchestd
cd install-orchestd
./installOrchestDDocker.sh
```

The installation will run some docker containers, and create a folder ~/orchestD

## Start, Stop 

Once done, the orchestD process will run and serve UI from [http://localhost:29000/](http://localhost:29000/).

To stop orchestD
```
orchestd.sh stop
```

To start orchestD again
```
orchestd.sh start
```

To update orchestD to latest version
```
orchestd.sh update
```


## Happy Coding!

You are ready to go!

Go to  [https://www.orchestd.io/api-design](https://www.orchestd.io/api-design) for a complete tutorial to your first orchestD experience.


## Contact

For any questions or requests: [info@orchestd.io](mailto:info@orchestd.io)


