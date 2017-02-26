#!/bin/bash

# -----------------------------------------------
# Author : Jiaobuzuji@163.com
# Abstract : For installing dependencies, software, tools and etc.
# Note : Before starting, you must choose a suitable software source(e.g. mirrors.ustc.edu.cn).
# -----------------------------------------------

# Config Bash
if [[ ! -f bashrc ]]; then
    echo -e "Can not find 'bashrc' file.\n"
else
    ln -s $(pwd)/inputrc ${HOME}/.inputrc
    ln -s $(pwd)/bash_logout ${HOME}/.bash_logout
    ln -s $(pwd)/bashrc ${HOME}/.bashrc
    ln -s $(pwd)/profile ${HOME}/.profile
fi


# -----------------------------------------------
# update software source
sudo apt-get update

# Miscellanies
# NOPROMPT=-y # uncomment to disable PROMPT during installation
ALLINSTALL=sudo apt-get install ${NOPROMPT}

${ALLINSTALL} automake autoconf curl wget git checkinstall ctags cscope
${ALLINSTALL} zsh tmux tree
${ALLINSTALL} ibgtk-3-dev libx11-dev libncurses5-dev libatk1.0-dev libcairo2-dev libxpm-dev libxt-dev
${ALLINSTALL} openssh-server
${ALLINSTALL} python-dev python-pip python3-dev python3-pip
${ALLINSTALL} libperl-dev
${ALLINSTALL} tcl8.5-dev
# ${ALLINSTALL} liblua5.3-dev liblua5.3-0
# ${ALLINSTALL} ruby-dev

# -----------------------------------------------
# Build
SOURCEDIR=${HOME}/buildsrc
mkdir -p ${SOURCEDIR}
# git clone https://github.com/ggreer/the_silver_searcher.git ${SOURCEDIR} && ${ALLINSTALL} automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev && 
#./build.sh && sudo make install

# -----------------------------------------------
# Remove default tools
# sudo apt-get remove vim-tiny vim-common vim-gui-common vim-nox vim-runtime vim gvim

# -----------------------------------------------
# Remove cache
echo -e "\nAll done!!Clean ...\n"
sudo apt-get autoremove -y
sudo apt-get autoclean
sudo apt-get clean
