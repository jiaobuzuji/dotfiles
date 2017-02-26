#!/bin/bash

# -----------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference :
# -----------------------------------------------

CURDIR=$(pwd)
SOURCEDIR=${HOME}/repos/

if [[ ! -d ${SOURCEDIR}/vim.git ]]; then
    mkdir -p ${SOURCEDIR}
    git clone https://github.com/vim/vim.git ${SOURCEDIR}
fi

ln -sf ${CURDIR}/buildmyvim.sh ${SOURCEDIR}/vim.git && \
cd ${SOURCEDIR}/vim.git && \
sudo source buildmyvim.sh && \
cd ${CURDIR}


