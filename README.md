# orchestD Installation and Usage Manual
This manual describes installation and usage of orchestD.

## Prerequisites 

orchestD is currenctly supported on main linux distributions.

In order to run orchestD, have the following installed on your computer:
* [golang 1.19+](https://go.dev/doc/install)    
* [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [Docker Engine](https://docs.docker.com/engine/install/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* [Goland IDE](https://www.jetbrains.com/go/)


## GitHub

If your git cli is not configured to use github, please complete the [github cli connection process](https://github.com/orchestd/install/tree/main/connect-github.md)

## Installation

Open a terminal, cd to the desired destination folder, clone the installtion repo and run the installer:
```
$ cd path/to/folder
$ git clone https://github.com/orchestd/install.git instal-orchestd
$ cd instal-orchestd
$ ./installOrchestDDocker.sh
```

The installation will run some docker containers, and create a folder ~/orchestD

## Start, Stop 

Once done, the orchestD process will run and serve UI from [http://localhost:29000/](http://localhost:29000/).

To stop orchestD
```
$ orchestd.sh stop
```

To start orchestD again
```
$ orchestd.sh start
```

## Happy Coding!

You are ready to go!

Go to  [https://www.orchestd.io/api-design](https://www.orchestd.io/api-design) for a complete tutorial to your first orchestD experience.


