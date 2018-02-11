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

# # set the separator to \n
OLD_IFS="$IFS"

# -----------------------------------------------
# install something
GIT_CONFIG="./ubuntu.ini"
DED_DIR="${HOME}/Downloads/debs/"
SRC_DIR="${HOME}/Downloads/buildsrc"
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
    IFS=","
    # for i in $1
    local filename="${DED_DIR}/tmp$(date +%Y%m%d%H%M%S).deb"
        wget -c $1 -O ${filename}  || echo -e "Wget $1 failed\n"
        sudo dpkg -i ${filename} || ( sudo apt-get -f install --fix-missing -y; sudo dpkg -i ${filename}  \
            || echo -e "dpkg install ${filename}  form $1 failed\n")
    IFS=$'\x0A'
}

IFS=$'\x0A'
echo -e "\n\nDeb install ...\n"
deb_list=$(git config --get-all deb.url)
if [[ $deb_list != "" ]]; then
    mkdir -p ${DED_DIR}
fi
for i in ${deb_list}; do
    if [[ $i != "" ]]; then
        read -n1 -p "download the '${i}' package ? (y/N) " ans
        if [[ $ans =~ [Yy] ]]; then
            DebInstall $i
        fi
    fi
done

# Build Source
function child_shell_execute()
{
    local tmp="echo ${mypasswd} |sudo -S "
    bash -c "$(echo $1 | sed "s/\<sudo\>/${tmp}/g")"
}

function BuildSrc()
{
    IFS=","
    local -i count=0
    local proj_str=""
    for i in $1; do
        case ${count} in
            0 )
                IFS=${OLD_IFS}
                proj_dir=${SRC_DIR}/$(basename $i .git)
                if [[ ! -d ${proj_dir}  ]]; then
                    git clone --depth=1 $i ${proj_dir}/ || echo -e "git clone $i failed\n"
                else
                    echo -e "\n\nUpdating $(basename $i .git)'s source code ...\n"
                    cd  ${proj_dir}
                    git checkout -- .
                    git pull || echo -e "Update source $(basename $i .git) failed\n"
                fi
                ;;
            1 )
                ${INSTALLALL} $i
                ;;
            2 )
                child_shell_execute "cd ${proj_dir} && $i"
                ;;
            *)
                echo -e "Wrong ini format in build section\n"
                ;;
        esac
        let "count+=1"
    done
    cd ${ROOT_DIR}
    IFS=$'\x0A'
}

IFS=$'\x0A'
echo -e "\n\nInstall software from source ...\n"
src_list=$(git config --get-all build.gitsrc)
if [[ $src_list != "" ]]; then
    mkdir -p ${SRC_DIR}
fi
for i in ${src_list}; do
    if [[ $i != "" ]]; then
        read -n1 -p "Install Source: '${i}' ? (y/N) " ans
        if [[ $ans =~ [Yy] ]]; then
            BuildSrc $i
        fi
    fi
done

sudo snap install rg

# # -----------------------------------------------
# # Remove default tools
# # sudo apt-get remove vim-tiny vim-common vim-gui-common vim-nox vim-runtime vim gvim
#
# -----------------------------------------------
# Remove cache
echo -e "\nAll done!!Clean ...\n"
sudo apt-get autoremove -y
sudo apt-get autoclean
sudo apt-get clean

