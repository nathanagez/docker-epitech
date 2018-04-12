# docker-epitech
Docker installation script to perfom tests  under national dump using a Fedora26 container

## Installation

With curl
```shell
curl -O https://raw.githubusercontent.com/NastyZ98/docker-epitech/master/docker-install.sh && chmod +x docker-install.sh
```

## How to use

```shell
USAGE :
        ./docker-install.sh [FLAG] [OPTION]
FLAGS :
        --install       Install
        --uninstall     Uninstall docker
        --clean         Remove old docker version
OPTIONS :
        --ubuntu        Process on linux
        --OSX           (Not actually available) Process on Mac Systems
```

## Demo
![GIF](https://raw.githubusercontent.com/NastyZ98/docker-epitech/master/demo/demo.gif)

## Changelog
### docker-install.sh [2.4] - 2018-04-12
### docker-compile [1.7] - 2018-04-12
#### Change
- Edited font

### docker-compile [1.6] - 2018-04-12
#### Fix
- Fix folder check
- Fix PATH export
#### Change
- Removed .sh extension
### docker-install.sh [2.3] - 2018-04-12
- Fix folder check to perform a copy of docker-compile
- Fix PATH export

### docker-compile.sh [1.3] - 2018-04-12
#### Fix
- Fix permissions with docker daemon
- Fix update function that doesn't copy script file in /usr/bin
### docker-install.sh [2.1] - 2018-04-12
- Fix automatic yes to prompts
- Fix permissions with docker daemon