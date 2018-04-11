#!/bin/bash

function display_help() {
        echo -e "\e[1m\e[21mUSAGE : \n\t" $0 " [FLAG] [OPTION]"
        echo -e "FLAGS :"
        echo -e "\t--install            \e[1mInstall\e[21m"
        echo -e "\t--uninstall          \e[1mUninstall docker\e[21m"
        echo -e "\t--clean              \e[1mRemove old docker version\e[21m"
        echo -e "OPTIONS :"
        echo -e "\t--ubuntu              \e[1mProcess on linux\e[21m"
        echo -e "\t--OSX                \e[1mProcess on Mac Systems\e[21m"
        exit
}

function clean_linux() {
        sudo apt-get remove docker docker-engine docker.io &> logs
        if [ $? -eq 0 ]; then
                echo -e "\e[32m\e[39mCheck for docker"
                echo -e "\e[32m\e[39mCheck for docker-engine"
                echo -e "\e[32m\e[39mCheck for docker.io"
                echo -e "\e[1m\e[32m[+] OK"
        else
                echo -e "\e[91m[-] Error check logs\e[39m"
                erreur=1
        fi
}

function install_linux() {
        sudo apt-get update &> logs
        if [ $? -ne 0 ]; then
                echo -e "\e[91m[-] Error while updating sources\e[39m"
        fi
        sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common &> logs
        if [ $? -eq 0 ]; then
                echo -e "\e[1m\e[32m[+] \e[39mapt-transport-https"
                echo -e "\e[1m\e[32m[+] \e[39mca-certificates"
                echo -e "\e[1m\e[32m[+] \e[39mcurl"
                echo -e "\e[1m\e[32m[+] \e[39msoftware-properties-common"
        fi
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &> logs
        if [ $? -eq 0 ]; then
                echo -e "\e[1m\e[32m[+] \e[39mAdded key from https://download.docker.com/linux/ubuntu/gpg"
        fi
        sudo apt-key fingerprint 0EBFCD88
        sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable" &> logs
        if [ $? -eq 0 ]; then
                echo -e "\e[1m\e[32m[+] \e[39mAdded stable repository"
        fi
        sudo apt-get update &> logs
        echo -e "\e[1m\e[32m[+] \e[39mInstallation of docker-ce ..."
        sudo apt-get install docker-ce &> logs
        if [ $? -eq 0 ]; then
                echo -e "\e[1m\e[32m[+] \e[39mdocker-ce successfully installed"
        fi
        if [ $? -eq 0 ]; then
                echo -e "\e[1m\e[32m[+] \e[39mTesting installation ..."
        fi
        sudo docker run hello-world
        if [ $? -eq 0 ]; then
                echo -e "\e[1m\e[32m[+] \e[39mDocker is now installed and is working correctly"
        fi
        curl -O https://raw.githubusercontent.com/NastyZ98/docker-epitech/master/docker-compile.sh
        mv docker-compile.sh /usr/bin
        chmod +x /usr/bin/docker-compile.sh
}

if [ $# -eq 0 ]; then
        display_help
fi

if [ $1 = "--clean" ] && [ $2 = "--ubuntu" ]
then
        clean_linux
        exit
elif [ $1 = "--install" ] && [ $2 = "--ubuntu" ]
then
        install_linux
        exit
else
        display_help
        exit
fi