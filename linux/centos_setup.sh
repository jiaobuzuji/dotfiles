#!/usr/bin/env bash

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
GIT_CONFIG="./centos.ini"
DED_DIR="${HOME}/Downloads/rpms/"
NOPROMPT=-y # uncomment to disable PROMPT during installation
INSTALLALL="sudo yum install ${NOPROMPT}"

# pre-install
export GIT_CONFIG

read -n1 -p "update source? (y/N) " ans
if [[ $ans =~ [Yy] ]]; then
    sudo yum update
    ${INSTALLALL} automake autoconf curl wget git checkinstall ctags cscope

    sudo yum update
    # sudo yum upgrade
fi


# install yum
yum_list=$(git config --get-all yum.packages)
echo -e "${yum_list}\n"
for i in ${yum_list}; do
    if [[ $i != "" ]]; then
	echo -e "\n\nyum '$i' will install ...\n"
        ${INSTALLALL} $i || echo -e "yum install failed : $i\n"
    fi
done

# # install deb package
# function DebInstall()
# {
#     local filename="${DED_DIR}/tmp$(date +%Y%m%d%H%M%S).deb"
#         rpm -c $1 -O ${filename}  || echo -e "Wget $1 failed\n"
#         sudo dpkg -i ${filename} || ( sudo yum -f install --fix-missing -y; sudo dpkg -i ${filename}  \
#             || echo -e "dpkg install ${filename}  form $1 failed\n")
# }
# 
# echo -e "\n\nrpm install ...\n"
# deb_list=$(git config --get-all deb.url)
# if [[ $deb_list != "" ]]; then
#     mkdir -p ${DED_DIR}
# fi
# for i in ${deb_list}; do
#     if [[ $i != "" ]]; then
#         DebInstall $i
#     fi
# done
# 
# # SOURCEDIR="${HOME}/Downloads/buildsrc"
# # mkdir -p ${SOURCEDIR}

# # Build
# # git clone --depth=1 https://github.com/ggreer/the_silver_searcher.git ${SOURCEDIR} && ${INSTALLALL} automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev && 
# #./build.sh && sudo make install
# 
# # -----------------------------------------------
# # Remove default tools
# # sudo yum remove vim-tiny vim-common vim-gui-common vim-nox vim-runtime vim gvim
# 
# # -----------------------------------------------
# # Remove cache
# echo -e "\nAll done!!Clean ...\n"
# sudo yum autoremove
# sudo yum autoclean
# sudo yum clean


