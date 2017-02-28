#!/bin/bash

# -----------------------------------------------
# Author : Jiaobuzuji@163.com
# Abstract : For installing dependencies, software, tools and etc.
# Note : Before starting, you must choose a suitable software source(e.g. mirrors.ustc.edu.cn).
# -----------------------------------------------

# -----------------------------------------------
# Config Bash
if [[ ! -f inputrc ]]; then
    echo -e "Can not find 'bashrc' file.\n"
else
    ln -s $(pwd)/inputrc ${HOME}/.inputrc
    ln -s $(pwd)/bash_logout ${HOME}/.bash_logout
    ln -s $(pwd)/bashrc ${HOME}/.bashrc
    ln -s $(pwd)/profile ${HOME}/.profile
fi


# -----------------------------------------------
# install something
GIT_CONFIG="./ubuntu.ini"
DED_DIR="${HOME}/Downloads/debs/"
# NOPROMPT=-y # uncomment to disable PROMPT during installation
INSTALLALL="sudo apt-get install ${NOPROMPT}"

# pre-install
export GIT_CONFIG

read -n1 -p "update source? (y/N) " ans
if [[ $ans =~ [Yy] ]]; then
    sudo apt-get update
    ${INSTALLALL} automake autoconf curl wget git checkinstall ctags cscope

    ARCH=$(git config --get-all info.arch)
    if [[ ${ARCH} == "x64" ]]; then
        echo -e "\n\nAdding i386 packages support ...\n"
        sudo dpkg --add-architecture i386
    fi

    ppa_list=$(git config --get-all repo.ppa)
    echo -e "\n\nadding ppa ...\n"
    for i in ${ppa_list}; do
        if [[ $i != "" ]]; then
            sudo add-apt-repository -y $i || echo -e "apt-add-repository failed : $i\n"
            sleep 1
        fi
    done

    sudo apt-get update
    # sudo apt-get upgrade
fi


# install apt
apt_list=$(git config --get-all apt.packages)
for i in ${apt_list}; do
    if [[ $i != "" ]]; then
	echo -e "\n\nApt '$i' will install ...\n"
        ${INSTALLALL} $i || echo -e "apt-get install failed : $i\n"
    fi
done

# install deb package
function DebInstall()
{
    local filename="${DED_DIR}/tmp$(date +%Y%m%d%H%M%S).deb"
        wget -c $1 -O ${filename}  || echo -e "Wget $1 failed\n"
        sudo dpkg -i ${filename} || ( sudo apt-get -f install --fix-missing -y; sudo dpkg -i ${filename}  \
            || echo -e "dpkg install ${filename}  form $1 failed\n")
}

echo -e "\n\nDeb install ...\n"
deb_list=$(git config --get-all download.url)
if [[ $deb_list != "" ]]; then
    mkdir -p ${DED_DIR}
fi
for i in ${deb_list}; do
    if [[ $i != "" ]]; then
        DebInstall $i
    fi
done

# # SOURCEDIR="${HOME}/Downloads/buildsrc"
# # mkdir -p ${SOURCEDIR}

# # Build
# # git clone --depth=1 https://github.com/ggreer/the_silver_searcher.git ${SOURCEDIR} && ${INSTALLALL} automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev && 
# #./build.sh && sudo make install
# 
# # -----------------------------------------------
# # Remove default tools
# # sudo apt-get remove vim-tiny vim-common vim-gui-common vim-nox vim-runtime vim gvim
# 
# # -----------------------------------------------
# # Remove cache
# echo -e "\nAll done!!Clean ...\n"
# sudo apt-get autoremove
# sudo apt-get autoclean
# sudo apt-get clean

