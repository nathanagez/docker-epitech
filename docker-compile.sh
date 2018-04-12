#!/bin/bash

function checkVersion() {
        version=$(curl -s https://raw.githubusercontent.com/NastyZ98/docker-epitech/master/version | head -n 1 )
        if [ "$version" != "1.7" ]; then
                echo -e "\e[1m\e[32m[+] \e[0mNew update available ..."
                if [ ! -d ~/bin/ ]; then
                        mkdir ~/bin/
                        export PATH=~/bin/:$PATH
                        echo -e "\e[1m\e[32m[+] \e[0m~/bin/ added to PATH"
                fi
                sudo curl -o ~/bin/docker-compile.tmp https://raw.githubusercontent.com/NastyZ98/docker-epitech/master/docker-compile.sh
                echo -e "\e[1m\e[32m[+] \e[0mDownloaded"
                sudo mv ~/bin/docker-compile ~/bin/docker-compile.old
                sudo mv ~/bin/docker-compile.tmp ~/bin/docker-compile
                sudo rm -f ~/bin/docker-compile.old
                sudo chmod +x ~/bin/docker-compile
                if [ -e /usr/bin/docker-compile.sh ]
                then
                        echo -e "\e[1m\e[32m[+] \e[0mOld version found in /usr/bin/"
	                sudo rm -f /usr/bin/docker-compile.sh
                        echo -e "\e[1m\e[32m[+] \e[0mDeleted"
                fi
                echo -e "\e[1m\e[32m[+] \e[0mDone. Restart your script"
                exit
        fi
}

function display_help() {
        echo -e "\e[1mUSAGE :\e[0m\n\t docker-compile \e[1m[FLAG] [FLAG] [OPTION]\e[0m"
        echo -e "\e[1mFLAGS :\e[0m"
        echo -e "\t-m          Compile project"
        echo -e "\e[1mOPTIONS :\e[0m"
        echo -e "\t-v          Start valgrind after compilation, binary name is required"
        echo -e "\t-i          Start project after compilation, binary name is required"
        exit
}

function copyWorkspace() {
        sudo docker cp $1 epi:/home/compilation/
}

function startContainer() {
        sudo docker container run -d -ti --name epi epitechcontent/epitest-docker bash &> /dev/null
        copyWorkspace $1
}

function deleteContainer() {
        sudo docker container rm -f epi &> /dev/null
}

function compileProject() {
        sudo docker container exec epi bash -c "cd /home/compilation/ && make"
        if [ $? != 0 ]; then
                echo -e "\n\e[31m/!\ BUILD FAIL\e[0m"
                return 1
        else
                echo -e "\n\e[92m[+] BUILD COMPLETE\e[0m"
                return 0
        fi

}

function checkImageExist() {

        image=$(sudo docker images -f "reference=epitechcontent/epitest-docker" --format "{{.Repository}}")

        if [ -z "$image" ]; then
                echo -e "\e[1m\e[32m[+] \e[0mImage not found locally, it will be dowloaded from the Hub"
                sudo docker pull epitechcontent/epitest-docker
                startContainer $1
        else
                echo -e "\e[1m\e[32m[+] \e[0mImage found locally"
                echo -e "\e[1m\e[32m[+] \e[0mCopy file from host to container ..."
                startContainer $1
        fi
}

if [ $# -eq 0 ]; then
        checkVersion
        display_help
        exit
fi

if [ ! -z $1 ] && [ $2 == "-m" ]; then
        checkVersion
        checkImageExist $1
        compileProject
        if [ $? -eq 0 ] && [ ! -z $3 ]; then
                if [ $3 == "-v" ] && [ ! -z $4 ]; then
                        echo -e "\n\e[0m\e[96m========VALGRIND========\e[0m"
                        sudo docker container exec -ti epi bash -c "cd /home/compilation/ ; valgrind ./$4 $5 $6"
                elif [ $3 == "-i" ] && [ ! -z $4 ]; then
                        echo -e "\n\e[0m\e[96m========LIVE EXEC========\e[0m"
                        sudo docker container exec -ti epi bash -c "cd /home/compilation/ ; ./$4 $5 $6"
                fi
        fi
        deleteContainer
else
        checkVersion
        display_help
        exit
fi