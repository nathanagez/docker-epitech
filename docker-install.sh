#!/bin/bash

function display_help() {
        echo -e "\e[1mUSAGE :\e[0m \n\t docker-install.sh \e[1m[FLAG]\e[0m"
        echo -e "\e[1mFLAGS :\e[0m"
        echo -e "\t--install            Install"
        echo -e "\t--uninstall          Uninstall docker"
        echo -e "\t--clean              Remove old docker version"
        exit
}

function clean_linux() {
        sudo apt-get remove docker docker-engine docker.io &> logs
        if [ $? -eq 0 ]; then
                echo -e "Check for docker\e[1m\e[32m OK\e[0m"
                echo -e "Check for docker-engine\e[1m\e[32m OK\e[0m"
                echo -e "Check for docker.io\e[1m\e[32m OK\e[0m"
        else
                echo -e "\e[1m\e[91m[-] \e[0mError check logs"
        fi
}

function uninstall_linux() {
        sudo apt-get remove -y docker-ce &> logs
        echo -e "\e[1m\e[32m[+] \e[0mdocker-ce removed"
        if [ -e ~/bin/docker-compile ]; then
                sudo rm -f ~/bin/docker-compile
                echo -e "\e[1m\e[32m[+] \e[0mdocker-compile script removed from ~/bin/"
        fi
        exit
}

function install_linux() {
        sudo apt-get update -y &> logs
        if [ $? -ne 0 ]; then
                echo -e "\e[1m\e[91m[-] \e[0mError while updating sources"
                exit
        fi
        sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common -y &> logs
        if [ $? -eq 0 ]; then
                echo -e "\e[1m\e[32m[+] \e[0mapt-transport-https"
                echo -e "\e[1m\e[32m[+] \e[0mca-certificates"
                echo -e "\e[1m\e[32m[+] \e[0mcurl"
                echo -e "\e[1m\e[32m[+] \e[0msoftware-properties-common"
        fi
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &> logs
        if [ $? -eq 0 ]; then
                echo -e "\e[1m\e[32m[+] \e[0mAdded key from https://download.docker.com/linux/ubuntu/gpg"
        fi
        sudo apt-key fingerprint 0EBFCD88 &> logs
        sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable" &> logs
        if [ $? -eq 0 ]; then
                echo -e "\e[1m\e[32m[+] \e[0mAdded stable repository"
        fi
        sudo apt-get update -y &> logs
        echo -e "\e[1m\e[32m[+] \e[0mInstalling docker-ce ..."
        sudo apt-get install docker-ce -y &> logs
        if [ $? -eq 0 ]; then
                echo -e "\e[1m\e[32m[+] \e[0mdocker-ce successfully installed"
        fi
        if [ $? -eq 0 ]; then
                echo -e "\e[1m\e[32m[+] \e[0mTesting installation ..."
        fi
        sudo docker run hello-world &> /dev/null
        if [ $? -eq 0 ]; then
                echo -e "\e[1m\e[32m[+] \e[0mDocker is now installed and is working properly"
        fi
        echo -e "\e[1m\e[32m[+] \e[0mRemoving docker containers ..."
        sudo docker container rm -f $(sudo docker ps -aq) &> /dev/null
        echo -e "\e[1m\e[32m[+] \e[0mDone\n\e[1m\e[32m[+] \e[0mDonwloading docker-compile ..."
        curl -s -o docker-compile https://raw.githubusercontent.com/NastyZ98/docker-epitech/master/docker-compile.sh
        echo -e "\e[1m\e[32m[+] \e[0mDone"
        if [ ! -d ~/bin/ ]; then
                mkdir ~/bin/
                export PATH=~/bin/:$PATH
        fi
        sudo mv docker-compile ~/bin/
        sudo chmod +x ~/bin/docker-compile
        echo -e "\e[1m\e[32m[+] \e[0mMoved to ~/bin/\n\n\e[0m\e[96mDon't forget to Star my repository - by Nathan Agez Epitech Montpellier Promo 2022\n\n"
}

version=$(curl -s https://raw.githubusercontent.com/NastyZ98/docker-epitech/master/version | tail -n 1 )

function checkVersion() {
        if [ $version != "2.4" ]; then
                echo -e "\e[1m\e[32m[+]\e[0m New update available ..."
                curl -o docker-install.tmp https://raw.githubusercontent.com/NastyZ98/docker-epitech/master/docker-install.sh
                echo -e "\e[1m\e[32m[+]\e[0m Done"
                mv $0 docker-install.old
                echo -e "\e[1m\e[32m[+]\e[0m Renaming actual instance ..."
                mv docker-install.tmp docker-install.sh
                rm -f docker-install.old
                echo -e "\e[1m\e[32m[+]\e[0m Old instance deleted"
                chmod +x docker-install.sh
                echo -e "\e[1m\e[32m[+]\e[0m Done restart script"
                exit
        fi
}

if [ $# -eq 0 ]; then
        checkVersion $version
        display_help
fi

if [ $1 = "--clean" ]
then
        clean_linux
        exit
elif [ $1 = "--install" ]
then
        checkVersion $version
        install_linux
        exit
elif [ $1 == "--uninstall" ]
then
        checkVersion $version
        uninstall_linux
else
        checkVersion $version
        display_help
        exit
fi