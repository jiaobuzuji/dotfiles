#!/usr/bin/env bash

# -----------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference :
# -----------------------------------------------

CURDIR=$(pwd)
SOURCEDIR=${HOME}/repos/

if [[ ! -d ${SOURCEDIR}/vim.git ]]; then
    mkdir -p ${SOURCEDIR} && cd ${SOURCEDIR}
    git clone --depth=1 https://github.com/vim/vim.git vim.git
fi

cp -vf ${CURDIR}/buildmyvim.sh ${SOURCEDIR}/vim.git && \
cd ${SOURCEDIR}/vim.git && \
source buildmyvim.sh && \
cd ${CURDIR}

if [[ ! -d ${SOURCEDIR}/vimrc.git ]]; then
    mkdir -p ${SOURCEDIR} && cd ${SOURCEDIR}
    git clone --depth=1 https://github.com/jiaobuzuji/vimrc.git vimrc.git
    ln -s ${SOURCEDIR}/vimrc.git ${HOME}/.vim
fi

curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cd ${CURDIR}
