#!/bin/bash

function checkVersion() {
        version=$(curl -s https://raw.githubusercontent.com/NastyZ98/docker-epitech/master/version | head -n 1 )
        if [ "$version" != "1.0" ]; then
                echo -e "\e[1m\e[32m[+] \e[39mUpdating ..."
                sudo curl -o docker-compile.tmp https://raw.githubusercontent.com/NastyZ98/docker-epitech/master/docker-compile.sh
                sudo mv $0 docker-compile.old
                sudo mv docker-compile.tmp docker-compile.sh
                sudo rm -f docker-compile.old
                sudo chmod +x docker-compile.sh
                echo -e "\e[1m\e[32m[+] \e[39mDone restart script"
                exit
        fi
}

function display_help() {
        echo -e "\e[1m\e[21mUSAGE : \n\t" $0 " [PATH] [FLAG] [OPTION]"
        echo -e "FLAGS :"
        echo -e "\t--make               Compile project"
        echo -e "OPTIONS :"
        echo -e "\t--valgrind           Start valgrind after compilation"
        echo -e "\t--interactive        Start project"
        exit
}

function copyWorkspace() {
        docker cp $1 epi:/home/compilation/
}

function startContainer() {
        docker container run -d -t --name epi epitechcontent/epitest-docker bash &> /dev/null
        copyWorkspace $1
}

function deleteContainer() {
        docker container rm -f epi &> /dev/null
}

function compileProject() {
        docker container exec epi bash -c "cd /home/compilation/ && make"
        if [ $? != 0 ]; then
                echo -e "\n\e[31m/!\ BUILD FAIL\e[39m"
        else
                echo -e "\n\e[92m[+] BUILD COMPLETE\e[39m"
        fi
}

function checkImageExist() {

        image=$(docker images -f "reference=epitechcontent/epitest-docker" --format "{{.Repository}}")

        if [ -z "$image" ]; then
                echo -e "\e[1m\e[32m[+]\e[39m Image not found locally, it will be dowloaded from the Hub"
                docker pull epitechcontent/epitest-docker
                startContainer $1
                compileProject
                deleteContainer
        else
                echo -e "\e[1m\e[32m[+]\e[39m Image found locally"
                echo -e "Copy file from host to container ..."
                startContainer $1
                compileProject
                deleteContainer
        fi
}

if [ $# -eq 0 ]; then
        checkVersion
        display_help
        exit
fi

if [ ! -z $1 ] && [ $2 == "--make" ]; then
        checkVersion
        checkImageExist $1
        deleteContainer
else
        checkVersion
        display_help
        exit
fi