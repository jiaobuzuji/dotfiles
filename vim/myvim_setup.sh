#!/bin/bash

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

ln -sf ${CURDIR}/buildmyvim.sh ${SOURCEDIR}/vim.git && \
cd ${SOURCEDIR}/vim.git && \
source buildmyvim.sh && \
cd ${CURDIR}


