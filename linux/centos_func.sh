#! /usr/bin/env bash

# -----------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference : https://github.com/tracyone/dotfiles/
# Abstract : ubuntu bootstrap functions
# -----------------------------------------------

# function pkg_mirror()
# {
# }

function pkg_update()
{
  read -n1 -p "Update package source? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    sudo yum update
  fi
}

function pkg_cleanall()
{
  # sudo yum autoremove -y
  # sudo yum autoclean
  sudo yum clean
}

function pkg_install()
{
  for i in $1
  do
    which $i > /dev/null 2>&1
    if [ $? -ne 0 ]; then
      ret='1'
      error "Check '$i' : Fail. Try to install it automatically!"

      sudo yum install $1 -y || error "Installation of '$i' failure, please install it manually!"
    else
      ret='0'
      success "Check '$i' : Success!"
    fi
  done
}

function tmux_install()
{
  pkg_install "libevent2-devel"
  # which tmux > /dev/null
  # if [[ $? -ne 0 ]]; then
  #   if [[ ! -d "./temp/tmux" ]]; then
  #     cd temp
  #     echo "get latest tmux from internet then build and install"
  #     git clone https://github.com/tmux/tmux && cd tmux && ./autogen.sh && ./configure && make && sudo make install || ( echo "Error occured!exit.";exit 3 )
  #   fi
  #   cd ${APP_PATH}
  # fi
  # pkg_install "tmux" # install manual
}

# -----------------------------------------------
# vim:fdm=marker
